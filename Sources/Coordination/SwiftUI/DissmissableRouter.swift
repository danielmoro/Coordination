//
//  DissmissableRouter.swift
//
//
//  Created by Daniel Moro on 7.2.21..
//

import SwiftUI

public protocol DismissableRouter: AnyObject {
    var onDismiss: (() -> Void)? { get set }
}

public extension DismissableRouter {
    func dismiss() {
        onDismiss?()
    }
}

public extension DismissableRouter {
    func present<V: View, PresentationState>(content: V, item: Binding<PresentationState?>) -> some View where PresentationState: Identifiable {
        onDismiss = { [weak self] in
            item.wrappedValue = nil
            self?.onDismiss = nil
        }

        let destination = NavigationView { content.modal() }
        return ModalLinkWrapper(destination: destination, item: item)
    }
}

public extension DismissableRouter where Self: ViewRouter {
    func present<PresentationState>(item: Binding<PresentationState?>) -> some View where PresentationState: Identifiable {
        onDismiss = { [weak self] in
            item.wrappedValue = nil
            self?.onDismiss = nil
        }

        let destination = NavigationView { home().modal() }
        return ModalLinkWrapper(destination: destination, item: item)
    }
}

public extension DismissableRouter {
    func navigateTo<V: View, ID>(content: V, id: ID, item: Binding<ID?>) -> some View where ID: Hashable {
        onDismiss = { [weak self] in
            item.wrappedValue = nil
            self?.onDismiss = nil
        }
        return NavigationLinkWrapper(destination: content, tag: id, item: item)
    }
}

public extension DismissableRouter where Self: ViewRouter {
    func navigateTo<ID>(id: ID, item: Binding<ID?>) -> some View where ID: Hashable {
        onDismiss = { [weak self] in
            item.wrappedValue = nil
            self?.onDismiss = nil
        }
        return NavigationLinkWrapper(destination: home(), tag: id, item: item)
    }
}

struct ModalLinkWrapper<T: View, I: Identifiable>: View {
    var destination: T
    @Binding var item: I?

    var body: some View {
        EmptyView()
            .sheet(item: $item, content: { _ in
                self.destination
            })
    }
}

struct NavigationLinkWrapper<V: View, T: Hashable>: View {
    var destination: V
    var tag: T
    @Binding var item: T?
    var isDetailLink: Bool = true

    var body: some View {
        bodyWithDetail(useDetail: isDetailLink)
    }
    
    private func bodyWithDetail(useDetail: Bool) -> some View {
        #if os(iOS)
            return NavigationLink(
                destination: destination,
                tag: tag,
                selection: $item,
                label: { EmptyView() }
            ).isDetailLink(useDetail)
        #else
            return NavigationLink(
                destination: destination,
                tag: tag,
                selection: $item,
                label: { EmptyView() }
            )
        #endif
    }
}
