//
//  FurnitureView.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 7.2.21..
//

import ComposableArchitecture
import SwiftUI

struct FurnitureView: View {
    let store: FurnitureStore
    var body: some View {
        WithViewStore(store) { viewStore in
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: viewStore.binding(
                        keyPath: \.furniture.name,
                        send: FurnitureAction.form
                    ))
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: viewStore.binding(
                        keyPath: \.furniture.notes,
                        send: FurnitureAction.form
                    ))
                        .frame(height: 100)
                }
            }
        }
    }
}

struct FurnitureView_Previews: PreviewProvider {
    static var previews: some View {
        FurnitureView(
            store: FurnitureStore(
                initialState: FurnitureState(
                    furniture: Furniture(id: UUID(), name: "F2")
                ),
                reducer: FurnitureReducer.furnitureReducer,
                environment: FurnitureEnvironment()
            )
        )
    }
}
