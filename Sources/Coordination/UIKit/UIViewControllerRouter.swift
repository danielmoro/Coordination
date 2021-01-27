//
//  File.swift
//
//
//  Created by Daniel Moro on 19.1.21..
//

#if os(iOS)

    import UIKit

    public protocol UIViewControllerRouter {
        func present(_ viewController: UIViewController, animated: Bool)

        func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)

        func dismiss(animated: Bool)
    }

    public extension UIViewControllerRouter {
        func present(_ viewController: UIViewController, animated: Bool) {
            present(viewController, animated: animated, onDismissed: nil)
        }
    }

#endif
