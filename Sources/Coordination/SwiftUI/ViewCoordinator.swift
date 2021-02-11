//
//  ViewCoordinator.swift
//
//
//  Created by Daniel Moro on 7.2.21..
//

import SwiftUI

public protocol ViewCoordinator: DismissableRouter {
    var coordinators: [DismissableRouter] { get set }
}

public extension ViewCoordinator {
    func coordinate<R, V: View, PresentationState>(
        with router: R,
        content: V,
        item: Binding<PresentationState?>
    ) -> some View where R: CoordinatedRouter, PresentationState: Identifiable {
        coordinators.append(router)
        router.terminateCoordination = { [weak self] in
            if let index = self?.coordinators.firstIndex(where: { $0 === router }) {
                self?.coordinators.remove(at: index)
            }
        }
        return router.present(content: content, item: item)
    }

    func coordinate<R, V: View, ID>(
        with router: R,
        content: V, id: ID,
        item: Binding<ID?>
    ) -> some View where R: CoordinatedRouter, ID: Hashable {
        coordinators.append(router)
        router.terminateCoordination = { [weak self] in
            if let index = self?.coordinators.firstIndex(where: { $0 === router }) {
                self?.coordinators.remove(at: index)
            }
        }
        return router.navigateTo(content: content, id: id, item: item)
    }

    func coordinate<R>(with router: R) -> some View where R: ViewRouter & CoordinatedRouter {
        coordinators.append(router)
        router.terminateCoordination = { [weak self] in
            if let index = self?.coordinators.firstIndex(where: { $0 === router }) {
                self?.coordinators.remove(at: index)
            }
        }
        return router.home()
    }

    func dismiss() {
        let children = coordinators
        for child in children {
            child.dismiss()
        }
        onDismiss?()
    }
}
