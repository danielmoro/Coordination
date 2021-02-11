//
//  AppCoordinator.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 7.2.21..
//

import ComposableArchitecture
import Coordination
import SwiftUI

class AppCoordinator: ViewRouter, ViewCoordinator {
    var coordinators: [DismissableRouter] = []
    var onDismiss: (() -> Void)?
    let store: AppStore

    init(store: AppStore) {
        self.store = store
    }

    func home() -> some View {
        let houseStore = store.scope(state: \.houseState, action: AppAction.house(action:))
        let houseRouter = HouseCoordinator(store: houseStore)
        return coordinate(with: houseRouter)
    }
}
