//
//  RoomView.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture
import SwiftUI

struct RoomView: View {
    let store: Store<RoomState, RoomAction>
    let coordinator: RoomCoordinator
    var body: some View {
        form
    }

    var form: some View {
        Form {
            Section(header: Text("Name")) {
                nameFiled
            }

            Section(header: Text("Furniture")) {
                furnitureList
                newButton
            }
        }
    }

    var nameFiled: some View {
        WithViewStore(store) { viewStore in
            TextField("Name", text: viewStore.binding(
                keyPath: \.room.name,
                send: RoomAction.form
            ))
        }
    }

    var furnitureList: some View {
        WithViewStore(store) { viewStore in
            ForEach(viewStore.room.furniture) { furniture in
                Button(action: {
                    viewStore.send(.setNavigation(selection: furniture.id))
                }, label: {
                    Text(furniture.name)
                        .withNavigation(
                            to: coordinator.navigate(
                                id: furniture.id,
                                item: viewStore.binding(
                                    get: \.selection?.id,
                                    send: RoomAction.setNavigation(selection:)
                                )
                            )
                        )
                })
            }
        }
    }

    var newButton: some View {
        WithViewStore(store) { viewStore in
            Button {
                viewStore.send(.setPresentation(.newFurniture))
            } label: {
                Label("Add Furniture", systemImage: "plus")
                    .labelStyle(IconOnlyLabelStyle())
                    .withNavigation(
                        to: coordinator.presentModal(
                            item: viewStore.binding(
                                get: \.presentation,
                                send: RoomAction.setPresentation
                            )
                        )
                    )
            }
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomCoordinator(store: RoomStore(
            initialState: RoomState(room: sampleRoom),
            reducer: RoomReducer.roomReducer,
            environment: RoomEnvironment()
        )).home()
    }
}
