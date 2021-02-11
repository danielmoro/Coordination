//
//  FurnitureCore.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture

typealias FurnitureStore = Store<FurnitureState, FurnitureAction>

struct FurnitureState: Equatable {
    var furniture: Furniture
}

enum FurnitureAction: Equatable {
    case form(BindingAction<FurnitureState>)
}

struct FurnitureEnvironment {}

typealias FurnitureReducer = Reducer<FurnitureState, FurnitureAction, FurnitureEnvironment>

extension FurnitureReducer {
    static let furnitureReducer = Reducer { _, action, _ in
        switch action {
        case .form:
            return .none
        }
    }.binding(action: /FurnitureAction.form)
}
