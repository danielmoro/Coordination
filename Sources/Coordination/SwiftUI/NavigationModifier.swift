//
//  NavigationModifier.swift
//  TimeRx
//
//  Created by Daniel Moro on 10.1.21..
//

import SwiftUI

public struct NavigationModifier: ViewModifier {
    @Binding var presentingView: AnyView?

    public func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(destination: presentingView, isActive: Binding(
                    get: { self.presentingView != nil },
                    set: { if !$0 {
                        self.presentingView = nil
                    }}
                )) {
                    EmptyView()
                }
            )
    }
}
