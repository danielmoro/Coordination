//
//  Coordinator.swift
//  
//
//  Created by Daniel Moro on 18.1.21..
//

/**
  Removed
    router: Router { get }
    protocol from original patter. Only benefit is automatic call of dismiss method,
    while keeping it in here preventing me from using generic routers with different techologies like UINavigation and SwiftUI
 */

public protocol Coordinator: class {

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
          let child = child else {
            return
        }
        self.removeChild(child)
        onDismissed?()
    })
  }
  
  private func removeChild(_ child: Coordinator) {
    guard let index = children.firstIndex(
      where: { $0 === child }) else {
        return
    }
    children.remove(at: index)
  }
}

