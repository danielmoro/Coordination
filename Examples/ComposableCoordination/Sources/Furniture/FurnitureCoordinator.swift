//
//  FurnitureCoordinator.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 8.2.21..
//

import Coordination
import SwiftUI

class FurnitureCoordinator: ViewRouter, CoordinatedRouter {
    init(store: FurnitureStore) {
        self.store = store
    }

    var terminateCoordination: () -> Void = {}
    var onDismiss: (() -> Void)?
    let store: FurnitureStore

    func home() -> some View {
        FurnitureView(store: store)
    }
}
