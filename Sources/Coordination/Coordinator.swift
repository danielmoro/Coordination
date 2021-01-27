//
//  Coordinator.swift
//
//
//  Created by Daniel Moro on 18.1.21..
//
/**
  - Note: Removed `var router: Router` in protocol from original pattern. Only benefit is automatic call of dismiss method,
    while keeping it in here preventing me from using generic routers with different techologies like `UINavigationController` and `SwiftUI`
 ### UIKit Usage Example
 ````
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
 ````
 ### SwiftUI Usage Example
 ````
 class DemoSwiftUICoordinator: Coordinator {
     var children: [Coordinator] = []

     func present(animated: Bool, onDismissed: (() -> Void)?) {
         let mainView = EmptyView()
         router.setRoot(mainView)
     }

     func dismiss(animated: Bool) {
         router.dismiss()
     }

     var router: Router = Router(isPresented: .constant(false))
 }
 ````
 */

public protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    func present(animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
    func presentChild(_ child: Coordinator,
                      animated: Bool,
                      onDismissed: (() -> Void)?)
}

extension Coordinator {
    public func presentChild(_ child: Coordinator,
                             animated: Bool,
                             onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(
            animated: animated,
            onDismissed: { [weak self, weak child] in
                guard let self = self,
                      let child = child
                else {
                    return
                }
                self.removeChild(child)
                onDismissed?()
            }
        )
    }

    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(
            where: { $0 === child })
        else {
            return
        }
        children.remove(at: index)
    }
}
