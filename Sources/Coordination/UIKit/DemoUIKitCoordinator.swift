//
//  DemoUIKitCoordinator.swift
//
//
//  Created by Daniel Moro on 19.1.21..
//

#if os(iOS)

    import UIKit

    class DemoUIKitCoordinator: Coordinator {
        init(navigationController: UINavigationController) {
            router = UINavigationRouter(navigationController: navigationController)
        }

        var children: [Coordinator] = []

        func present(animated: Bool, onDismissed: (() -> Void)?) {
            let mainVC = UIViewController()
            router.present(mainVC, animated: animated, onDismissed: nil)
        }

        func dismiss(animated: Bool) {
            router.dismiss(animated: animated)
        }

        private var router: UIViewControllerRouter
    }

#endif
