//
//  ComposableCoordinationApp.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture
import SwiftUI

@main
struct ComposableCoordinationApp: App {
    let store = Store(initialState: AppState(),
                      reducer: AppReducer.appReducer,
                      environment: AppEnvironment())
    var coordinator: AppCoordinator {
        AppCoordinator(store: store)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                coordinator.home()
            }
        }
    }
}
