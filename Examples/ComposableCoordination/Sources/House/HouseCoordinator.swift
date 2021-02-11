//
//  HouseCoordinator.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 2.2.21..
//

import ComposableArchitecture
import Coordination
import Foundation
import SwiftUI

enum HousePresentation: Equatable, Identifiable {
    var id: HousePresentation {
        self
    }

    case newRoom
}

class HouseCoordinator: ViewRouter, CoordinatedRouter {
    var terminateCoordination = {}
    var onDismiss: (() -> Void)?
    let store: HouseStore

    init(store: HouseStore) {
        self.store = store
    }

    @ViewBuilder
    func presentModal(item: Binding<HousePresentation?>) -> some View {
        switch item.wrappedValue {
        case .none:
            EmptyView()
        case .newRoom:
            IfLetStore(store.scope(state: \.selection?.value, action: HouseAction.room(action:))) { roomStore in
                RoomCoordinator(store: roomStore).present(item: item)
            }
        }
    }

    func navigate(id: Room.ID, item: Binding<Room.ID?>) -> some View {
        IfLetStore(store.scope(state: \.selection?.value, action: HouseAction.room(action:))) { roomStore in
            RoomCoordinator(store: roomStore).navigateTo(id: id, item: item)
        }
    }

    func home() -> some View {
        HouseView(store: store, router: self)
    }
}
