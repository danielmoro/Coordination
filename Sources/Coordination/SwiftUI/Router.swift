//
//  Router.swift
//  TimeRx
//
//  Created by Daniel Moro on 10.1.21..
//

import SwiftUI

public protocol ViewRouter {
    func setRoot<V: View>(_ view: V)
    func navigateTo<V: View>(_ view: V, onDismiss: (() -> Void)?)
    func presentSheet<V: View>(_ view: V, onDismiss: (() -> Void)?)
    func dismiss()
}

public typealias ObservableViewRouter = ObservableObject & ViewRouter

public class Router: ObservableViewRouter {
    struct State {
        var root: AnyView?
        var navigating: AnyView?
        var presentingSheet: AnyView?
        var isPresented: Binding<Bool>
    }

    @Published private(set) var state: State
    private var onDismiss: (() -> Void)?

    public init(isPresented: Binding<Bool>) {
        state = State(isPresented: isPresented)
    }
}

extension Router {
    public func setRoot<V: View>(_ view: V) {
        state.root = AnyView(view)
    }

    public func navigateTo<V: View>(_ view: V, onDismiss: (() -> Void)?) {
        state.navigating = AnyView(view)
    }

    public func presentSheet<V: View>(_ view: V, onDismiss: (() -> Void)?) {
        state.presentingSheet = AnyView(view)
    }

    public func dismiss() {
        state.isPresented.wrappedValue = false
    }
}

extension Router {
    var isNavigating: Binding<Bool> {
        boolBinding(keyPath: \.navigating)
    }

    var isPresentingSheet: Binding<Bool> {
        boolBinding(keyPath: \.presentingSheet)
    }

    var isPresented: Binding<Bool> {
        state.isPresented
    }
}

private extension Router {
    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }

    func boolBinding<T>(keyPath: WritableKeyPath<State, T?>) -> Binding<Bool> {
        Binding(
            get: { self.state[keyPath: keyPath] != nil },
            set: {
                if !$0 {
                    self.state[keyPath: keyPath] = nil
                }
            }
        )
    }
}

public extension View {
    func navigation(_ router: Router) -> some View {
        modifier(NavigationModifier(presentingView: router.binding(keyPath: \.navigating)))
    }

    func sheet(_ router: Router) -> some View {
        modifier(SheetModifier(presentingView: router.binding(keyPath: \.presentingSheet)))
    }
}

public extension Router {
    var rootView: AnyView {
        state.root ?? AnyView(Color.white)
    }
}
