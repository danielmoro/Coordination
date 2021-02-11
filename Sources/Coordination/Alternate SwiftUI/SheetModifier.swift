//
//  SheetModifier.swift
//  TimeRx
//
//  Created by Daniel Moro on 10.1.21..
//

import SwiftUI

public struct SheetModifier: ViewModifier {
    @Binding var presentingView: AnyView?

    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: Binding(
                get: { self.presentingView != nil },
                set: { if !$0 {
                    self.presentingView = nil
                }}
            )
            ) {
                self.presentingView
            }
    }
}
