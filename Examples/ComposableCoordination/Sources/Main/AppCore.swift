//
//  AppCore.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture

typealias AppStore = Store<AppState, AppAction>

struct AppState: Equatable {
    var houseState = HouseState(house: House(name: "My House"))
}

enum AppAction: Equatable {
    case house(action: HouseAction)
}

struct AppEnvironment {}

typealias AppReducer = Reducer<AppState, AppAction, AppEnvironment>

extension AppReducer {
    static let pure = Reducer { _, action, _ in
        switch action {
        case .house:
            return .none
        }
    }

    static let appReducer = Reducer.combine(
        HouseReducer
            .houseReducer
            .pullback(
                state: \.houseState,
                action: /AppAction.house(action:),
                environment: { _ in HouseEnvironment() }
            ),
        pure
    )
}
