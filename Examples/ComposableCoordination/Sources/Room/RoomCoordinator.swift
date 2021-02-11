//
//  RoomCoordinator.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 7.2.21..
//

import ComposableArchitecture
import Coordination
import SwiftUI

class RoomCoordinator: ViewRouter, CoordinatedRouter {
    var terminateCoordination: () -> Void = {}
    var onDismiss: (() -> Void)?
    let store: RoomStore

    init(store: RoomStore) {
        self.store = store
    }

    func home() -> some View {
        RoomView(store: store, coordinator: self)
    }

    func navigate(id: Furniture.ID, item: Binding<Furniture.ID?>) -> some View {
        IfLetStore(store.scope(state: \.selection?.value, action: RoomAction.furniture(action:))) { furnitureStore in
            FurnitureCoordinator(store: furnitureStore).navigateTo(id: id, item: item)
        }
    }

    @ViewBuilder
    func presentModal(item: Binding<RoomState.Presentation?>) -> some View {
        switch item.wrappedValue {
        case .none:
            EmptyView()
        case .newFurniture:
            IfLetStore(store.scope(state: \.selection?.value, action: RoomAction.furniture(action:))) { furnitureStore in
                FurnitureCoordinator(store: furnitureStore).present(item: item)
            }
        }
    }
}
