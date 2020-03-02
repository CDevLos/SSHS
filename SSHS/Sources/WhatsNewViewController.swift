//
//  WhatsNewViewController.swift
//  WhatsNewKit-iOS
//
//  Created by Sven Tiigi on 19.05.18.
//  Copyright © 2018 WhatsNewKit. All rights reserved.
//

import SafariServices
import UIKit

// MARK: - WhatsNewViewController

/**
The `WhatsNewViewController` to easily showcase your awesome new app features.
Read more on: [https://github.com/SvenTiigi/WhatsNewKit](https://github.com/SvenTiigi/WhatsNewKit)
 
Simply pass your `WhatsNew` struct to the `WhatsNewViewController` initializer
and present it.

```
import WhatsNewKit

// Initialize WhatsNewViewController with WhatsNew
let whatsNewViewController = WhatsNewViewController(
    whatsNew: whatsNew
)
 
// Present it 🤩
self.present(whatsNewViewController, animated: true)
```
 
# Custom Configuration
 
 If you wish to customize the appearance of the `WhatsNewViewController` you can
 initialize it with a configured `WhatsNewViewController.Configuration`.

 ```
 // Initialize default Configuration
 var configuration = WhatsNewViewController.Configuration()

 // Customize the Configuration to your needs
 configuration.titleView.titleColor = .orange
 // ...

 // Initialize WhatsNewViewController with custom configuration
 let whatsNewViewController = WhatsNewViewController(
     whatsNew: whatsNew,
     configuration: configuration
 )
 ```
 
 # Themes
 
 Beside the aforementioned custom configuration you can make use of predefined themes.
 
 ```
 // Initialize WhatsNewViewController with a theme
 let whatsNewViewController = WhatsNewViewController(
     whatsNew: whatsNew,
     configuration: .init(theme: .darkRed)
 )
 ```
  
 # WhatsNewVersionStore
 
 If you pass a `WhatsNewVersionStore` to the initializer will become `optional`.
 The `WhatsNewViewController` will return nil during initialization if the `version` of your passed `WhatsNew` is
 contained in the `WhatsNewVersionStore`.

 ```
 // Initialize WhatsNewViewController with WhatsNewVersionStore
 let whatsNewViewController: WhatsNewViewController? = WhatsNewViewController(
     whatsNew: whatsNew,
     versionStore: myVersionStore
 )

 // Check if WhatsNewViewController is available to present it.
 if let controller = whatsNewViewController {
     // Present it as WhatsNewViewController is available
     // after init with WhatsNewVersionStore
     self.present(controller, animated: true)
 } else {
     // WhatsNewViewController is `nil`
     // this Version has already been presented
 }
 ```
 
 If the `version` is not contained in the `WhatsNewVersionStore` the `WhatsNewViewController` will
 automatically save the presented version inside the passed `WhatsNewVersionStore` to ensure that the presentation
 of your new app features only happens once.
*/
public final class WhatsNewViewController: UIViewController {
    
    // MARK: Properties
    
    /// The UserInterfaceIdiom
    static var userInterfaceIdiom = UIDevice.current.userInterfaceIdiom
    
    /// The preferred status bar style
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.view.backgroundColor?.isLight == true ? .default : .lightContent
    }
    
    /// The WhatsNew
    public let whatsNew: WhatsNew
    
    /// The Configuration
    var configuration: Configuration
    
    /// The VersionStore
    var versionStore: WhatsNewVersionStore?
    
    /// The TitleViewController
    lazy var titleViewController: UIViewController = WhatsNewTitleViewController(
        title: self.whatsNew.title,
        configuration: self.configuration
    )
    
    /// The ItemsViewController
    lazy var itemsViewController: UIViewController = WhatsNewItemsViewController(
        items: self.whatsNew.items,
        configuration: self.configuration
    )
    
    /// The ButtonViewController
    lazy var buttonViewController: UIViewController = WhatsNewButtonViewController(
        configuration: self.configuration,
        onPress: { [weak self] buttonType in
            // Handle Button Press
            self?.handlePress(buttonType: buttonType)
        }
    )
    
    // MARK: Initializer
    
    /// Designated Initializer with WhatsNew and Configuration
    ///
    /// - Parameters:
    ///   - whatsNew: The WhatsNew
    ///   - configuration: The Configuration. Default value `.init()`
    public init(whatsNew: WhatsNew,
                configuration: Configuration = .init()) {
        // Set WhatsNew
        self.whatsNew = whatsNew
        // Set Configuration
        self.configuration = configuration
        // Super init
        super.init(nibName: nil, bundle: nil)
        // Check if Device is iPad
        if WhatsNewViewController.userInterfaceIdiom == .pad {
            // Invoke iPad Adjustment closure
            self.configuration.padAdjustment(&self.configuration)
        }
    }
    
    /// Convenience optional initializer with WhatsNewVersionStore.
    /// Initializer checks via WhatsNewVersionStore if Version has already been presented.
    /// If a Version has been found the initializer will return nil.
    ///
    /// - Parameters:
    ///   - whatsNew: The WhatsNew
    ///   - configuration: The Configuration
    ///   - versionStore: The WhatsNewVersionStore
    public convenience init?(whatsNew: WhatsNew,
                             configuration: Configuration = .init(),
                             versionStore: WhatsNewVersionStore) {
        // Verify VersionStore has not stored the WhatsNew Version
        guard !versionStore.has(version: whatsNew.version) else {
            // Return nil as Version has already been presented
            return nil
        }
        // Self init with WhatsNew and Configuration
        self.init(
            whatsNew: whatsNew,
            configuration: configuration
        )
        // Set VersionStore
        self.versionStore = versionStore
    }
    
    /// Convenience Initializer with WhatsNew and a Theme
    ///
    /// - Parameters:
    ///   - whatsNew: The WhatsNew
    ///   - theme: The Theme
    public convenience init(whatsNew: WhatsNew, theme: Theme) {
        self.init(
            whatsNew: whatsNew,
            configuration: .init(theme)
        )
    }
    
    /// Convenience Initializer with WhatsNew, Theme and WhatsNewVersionStore
    /// Initializer checks via WhatsNewVersionStore if Version has already been presented.
    /// If a Version has been found the initializer will return nil.
    ///
    /// - Parameters:
    ///   - whatsNew: The WhatsNew
    ///   - theme: The Theme
    public convenience init?(whatsNew: WhatsNew,
                             theme: Theme,
                             versionStore: WhatsNewVersionStore) {
        self.init(
            whatsNew: whatsNew,
            configuration: .init(theme),
            versionStore: versionStore
        )
    }
    
    /// Initializer with Coder always returns nil
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    /// Deinit
    deinit {
        // Store WhatsNew Version
        self.storeWhatsNewVersion()
    }
    
    // MARK: View-Lifecycle
    
    /// View did load
    public override func viewDidLoad() {
        // Invoke super
        super.viewDidLoad()
        // Set background color
        self.view.backgroundColor = self.configuration.backgroundColor
        // Add Subviews
        self.addSubviews()
    }

}

// MARK: - Add Subviews

extension WhatsNewViewController {
    
    /// Add Subviews
    func addSubviews() {
        // Add TitleViewController with Constraints
        self.add(self.titleViewController, constraints: [
            self.titleViewController.view.topAnchor.constraint(
                equalTo: self.anchor.topAnchor,
                constant: self.configuration.titleView.insets.top
            ),
            self.titleViewController.view.leadingAnchor.constraint(
                equalTo: self.anchor.leadingAnchor,
                constant: self.configuration.titleView.insets.left
            ),
            self.titleViewController.view.trailingAnchor.constraint(
                equalTo: self.anchor.trailingAnchor,
                constant: -self.configuration.titleView.insets.right
            )
        ])
        // Add ButtonViewController with Constraints
        self.add(self.buttonViewController, constraints: [
            self.buttonViewController.view.leadingAnchor.constraint(
                equalTo: self.anchor.leadingAnchor,
                constant: self.configuration.completionButton.insets.left
            ),
            self.buttonViewController.view.trailingAnchor.constraint(
                equalTo: self.anchor.trailingAnchor,
                constant: -self.configuration.completionButton.insets.right
            ),
            self.buttonViewController.view.bottomAnchor.constraint(
                equalTo: self.anchor.bottomAnchor,
                constant: -self.configuration.completionButton.insets.bottom
            )
        ])
        // Add ItemsViewController with Constraints
        self.add(self.itemsViewController, constraints: [
            self.itemsViewController.view.topAnchor.constraint(
                equalTo: self.titleViewController.view.bottomAnchor,
                constant: self.configuration.itemsView.insets.top + self.configuration.titleView.insets.bottom
            ),
            self.itemsViewController.view.leadingAnchor.constraint(
                equalTo: self.anchor.leadingAnchor,
                constant: self.configuration.itemsView.insets.left
            ),
            self.itemsViewController.view.trailingAnchor.constraint(
                equalTo: self.anchor.trailingAnchor,
                constant: -self.configuration.itemsView.insets.right
            ),
            self.itemsViewController.view.bottomAnchor.constraint(
                equalTo: self.buttonViewController.view.topAnchor,
                constant: -(self.configuration.itemsView.insets.bottom + self.configuration.completionButton.insets.top)
            )
        ])
    }
    
}

// MARK: - Handle Button Press

extension WhatsNewViewController {
    
    /// Handle Button Press
    ///
    /// - Parameter buttonType: The Button type
    func handlePress(buttonType: WhatsNewButtonViewController.ButtonType) {
        // Switch on button type
        switch buttonType {
        case .completion:
            // Invoke HapticFeebdack for completion button
            self.configuration.completionButton.hapticFeedback?.execute()
            // Store WhatsNew Version
            self.storeWhatsNewVersion()
            // Switch on CompletionAction
            switch self.configuration.completionButton.action {
            case .dismiss:
                // Dismiss WhatsNewViewController
                self.dismiss(animated: true)
            case .custom(action: let action):
                // Perform custom action and pass self
                action(self)
            }
        case .detail:
            // Invoke HapticFeebdack for detail button
            self.configuration.detailButton?.hapticFeedback?.execute()
            // Switch on DetailAction
            switch self.configuration.detailButton?.action {
            case .some(.website(let urlString)):
                // Check if url is available
                guard let url = URL(string: urlString) else {
                    // URL unavailable
                    return
                }
                // Initialize SafariViewController
                let safariViewController = SFSafariViewController(url: url)
                // Check if iOS 10 or greater is available
                if #available(iOS 10.0, *) {
                    // Set tint color
                    safariViewController.preferredControlTintColor = self.configuration.tintColor
                    // Set Bar tint Color
                    safariViewController.preferredBarTintColor = self.configuration.backgroundColor
                }
                // Present ViewController
                self.present(safariViewController, animated: true)
            case .some(.custom(action: let action)):
                // Perform custom action and pass self
                action(self)
            case .none:
                break
            }
        }
    }
    
}

// MARK: - Store Version

extension WhatsNewViewController {
    
    /// Store presented WhatsNew Version
    func storeWhatsNewVersion() {
        // Store Version if VersionStore is available
        self.versionStore?.set(version: self.whatsNew.version)
        // Clear VersionStore
        self.versionStore = nil
    }
    
}

// MARK: Present/Push

public extension WhatsNewViewController {
    
    /// Present WhatsNewViewController
    ///
    /// - Parameters:
    ///   - viewController: The ViewController to present on
    ///   - animated: If present should be animated. Default value `true`
    ///   - completion: The completion closure. Default value `nil`
    func present(on viewController: UIViewController?,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        // Present WhatsNewViewController
        viewController?.present(self, animated: animated, completion: completion)
    }
    
    /// Push WhatsNewViewController
    ///
    /// - Parameters:
    ///   - navigationController: The NavigationController
    ///   - animated: Should be pushed animated. Default value `true`
    func push(on navigationController: UINavigationController?,
              animated: Bool = true) {
        // Push WhatsNewViewController
        navigationController?.pushViewController(self, animated: animated)
    }
    
}
