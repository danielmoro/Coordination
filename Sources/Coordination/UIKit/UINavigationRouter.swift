//
//  UINavigationRouter.swift
//
//
//  Created by Daniel Moro on 18.1.21..
//

#if os(iOS)

    import UIKit

    public class UINavigationRouter: NSObject {
        private let navigationController: UINavigationController
        private let routerRootController: UIViewController?
        private var onDismissForViewController: [UIViewController: () -> Void] = [:]

        public init(navigationController: UINavigationController) {
            self.navigationController = navigationController
            routerRootController =
                navigationController.viewControllers.first
            super.init()

            navigationController.delegate = self
        }
    }

    // MARK: - Router

    extension UINavigationRouter: UIViewControllerRouter {
        public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
            onDismissForViewController[viewController] = onDismissed
            navigationController.pushViewController(viewController, animated: animated)
        }

        public func dismiss(animated: Bool) {
            guard let routerRootController = routerRootController else {
                navigationController.popToRootViewController(animated: animated)
                return
            }
            performOnDismissed(for: routerRootController)
            navigationController.popToViewController(routerRootController, animated: animated)
        }

        private func performOnDismissed(for
            viewController: UIViewController) {
            guard let onDismiss =
                onDismissForViewController[viewController]
            else {
                return
            }
            onDismiss()
            onDismissForViewController[viewController] = nil
        }
    }

    // MARK: - UINavigationControllerDelegate

    extension UINavigationRouter: UINavigationControllerDelegate {
        public func navigationController(
            _ navigationController: UINavigationController,
            didShow _: UIViewController,
            animated _: Bool
        ) {
            guard let dismissedViewController =
                navigationController.transitionCoordinator?
                    .viewController(forKey: .from),
                    !navigationController.viewControllers
                    .contains(dismissedViewController)
            else {
                return
            }
            performOnDismissed(for: dismissedViewController)
        }
    }

#endif
