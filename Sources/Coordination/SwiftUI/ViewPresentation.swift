//
//  ViewPresentation.swift
//
//
//  Created by Daniel Moro on 3.10.20..
//

import SwiftUI

@available(iOS 14.0, *)
@available(OSX 11.0, *)
struct ModalView: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
    }
}

struct LegacyModalView: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    func body(content: Content) -> some View {
        content
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("Close")
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
    }
}


public extension View {
    @ViewBuilder
    func modal() -> some View {
        if #available(iOS 14.0, macOS 11.0, *) {
            modifier(ModalView())
        } else {
            modifier(LegacyModalView())
        }
    }
}
