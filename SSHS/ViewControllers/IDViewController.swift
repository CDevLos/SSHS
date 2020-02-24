//
//  IDViewController.swift
//  SSHS
//
//  Created by Carlos Hernandez on 2/9/20.
//  Copyright © 2020 Student Portal. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import Photos

class IDViewController: UIViewController, UITextFieldDelegate {
    
let imagepicker = UIImagePickerController()
    let defaults = UserDefaults.standard
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var Picture: UIImageView!
    @IBOutlet weak var SchoolLabel: UILabel!
    @IBOutlet weak var Class: UITextField!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Barcode: UIImageView!
    @IBOutlet weak var AddPictureButton: UIButton!
    @IBOutlet weak var AddBarcodeButton: UIButton!
    @IBOutlet weak var SaveInfo: UIButton!
    
    struct Keys {
        static let Name = "name"
        static let Class = "class"
        static let AddPictureButton = "picturebutton"
        static let AddBarcodeButton = "barcodebutton"
        static let SaveInfo = "savebutton"
    }
  
    override func viewDidLoad() {
         imagepicker.delegate = self
        super.viewDidLoad()
        getImageFromDocumentDirectory()
        getImageFromDocumentDirectory2()
        checkforname()
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("Access Granted")                } else {
                    print("access denied")
                }
            })
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(IDViewController.keyboarddismiss))
            view.addGestureRecognizer(tap)
            Name.delegate = self
            Class.delegate = self
   //set up UI Elements
    Utilities.styleFilledButton(AddPictureButton)
    Utilities.styleFilledButton(AddBarcodeButton)
    Utilities.styleFilledButton(SaveInfo)
    Utilities.styleTextField(Name)
    Utilities.styleTextField(Class)
        // Do any additional setup after loading the view.
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           Name.resignFirstResponder()
           Class.resignFirstResponder()
           return true
       }
       @objc func keyboarddismiss() {
              view.endEditing(true)
       }
    
    @IBAction func Save(_ sender: Any) {
            CreateFolderInDocumentDirectory()
            saveImageDocumentDirectory()
            savename()
            saveImageDocumentDirectory2()
    }
    
    @IBAction func ChoosePicture(_ sender: Any) {
        imagepicker.sourceType = .photoLibrary
              imagepicker.allowsEditing = true
checkPhotoLibraryPermission()
    }
    
    
    @IBAction func ChooseBarcode(_ sender: Any) {
        AddPictureButton.isEnabled = false
            AddBarcodeButton.isEnabled = false
       // AddBarcodeButton.isHidden = true
     //   AddPictureButton.isHidden = true
            imagepicker.sourceType = .photoLibrary
            imagepicker.allowsEditing = true
checkPhotoLibraryPermission()
        
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
        //handle authorized status
            self.present(imagepicker, animated: true, completion: nil)

        case .denied, .restricted :
        //handle denied status
            let alert = UIAlertController(title: "Notice", message: "Please Enable Image access to use image functions Settings -> SSHS -> Photos -> Allow Read and Write.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


                  @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                // as above
                    self.present(self.imagepicker, animated: true, completion: nil)

                case .denied, .restricted:
                // as above
                    print("Denied")
                case .notDetermined:
                // won't happen but still
                    print("Idk")
                @unknown default:
                    fatalError()
                }
            }
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                // as above
                    self.present(self.imagepicker, animated: true, completion: nil)

                case .denied, .restricted:
                // as above
                    print("Idk bro")
                case .notDetermined:
                // won't happen but still
                    print("IDK Man N/A")
                @unknown default:
                    fatalError()
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func checkforname(){
        let name = defaults.value(forKey: Keys.Name) as? String ?? ""
        let classe = defaults.value(forKey: Keys.Class) as? String ?? ""
        Name.text = name
        Class.text = classe
        }
    
    func savename() {
        defaults.set(Name.text!, forKey: Keys.Name)
        defaults.set(Class.text!, forKey: Keys.Class)
            }
    
    func CreateFolderInDocumentDirectory()
        {
       let fileManager = FileManager.default
       let PathWithFolderName = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("FolderName")
      
       print("Document Directory Folder Path :- ",PathWithFolderName)
           
       if !fileManager.fileExists(atPath: PathWithFolderName)
       {
           try! fileManager.createDirectory(atPath: PathWithFolderName, withIntermediateDirectories: true, attributes: nil)
            }
                }
    
    func getDirectoryPath() -> NSURL
            {
      // path is main document directory path
          
        let documentDirectoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        let pathWithFolderName = documentDirectoryPath.appendingPathComponent("FolderName")
        let url = NSURL(string: pathWithFolderName) // convert path in url
          
        return url!
            }
    
    func saveImageDocumentDirectory()
        {
        let fileManager = FileManager.default
        let url = (self.getDirectoryPath() as NSURL)
          
        let imagePath = url.appendingPathComponent("MyImage.png") // Here Image Saved With This Name ."MyImage.png"
        let urlString: String = imagePath!.absoluteString
          
        let ImgForSave = Picture.image // here i Want To Saved This Image In Document Directory
        let imageData = UIImage.pngData(ImgForSave!)
       
        fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
     }
    func getImageFromDocumentDirectory()
     {
         let fileManager = FileManager.default
           
         let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("MyImage.png") // here assigned img name who assigned to img when saved in document directory. Here I Assigned Image Name "MyImage.png"
           
         let urlString: String = imagePath!.absoluteString
           
         if fileManager.fileExists(atPath: urlString)
         {
             let GetImageFromDirectory = UIImage(contentsOfFile: urlString) // get this image from Document Directory And Use This Image In Show In Imageview
               
             Picture.image = GetImageFromDirectory
         }
         else
         {
             print("No Image Found")
         }
     }
    
    func saveImageDocumentDirectory2()
           {
           let fileManager = FileManager.default
           let url = (self.getDirectoryPath() as NSURL)
             
           let imagePath = url.appendingPathComponent("Barcode.png") // Here Image Saved With This Name ."MyImage.png"
           let urlString: String = imagePath!.absoluteString
             
           let ImgForSave = Barcode.image // here i Want To Saved This Image In Document Directory
           let imageData = UIImage.pngData(ImgForSave!)
          
           fileManager.createFile(atPath: urlString as String, contents: imageData(), attributes: nil)
        }
       func getImageFromDocumentDirectory2()
        {
            let fileManager = FileManager.default
              
            let imagePath = (self.getDirectoryPath() as NSURL).appendingPathComponent("Barcode.png") // here assigned img name who assigned to img when saved in document directory. Here I Assigned Image Name "MyImage.png"
              
            let urlString: String = imagePath!.absoluteString
              
            if fileManager.fileExists(atPath: urlString)
            {
                let GetImageFromDirectory = UIImage(contentsOfFile: urlString) // get this image from Document Directory And Use This Image In Show In Imageview
                  
                Barcode.image = GetImageFromDirectory
            }
            else
            {
                print("No Image Found")
            }
        }

    // end of non-extension Functions
}
extension IDViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if AddPictureButton.isEnabled == true {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                Picture.image = image
            }
        }
        if AddBarcodeButton.isEnabled == false {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                Barcode.image = image
               
            }
            
        }
       
        dismiss(animated: true, completion: nil)
    }
}
 
