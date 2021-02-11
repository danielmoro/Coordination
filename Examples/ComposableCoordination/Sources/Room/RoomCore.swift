//
//  RoomCore.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture

typealias RoomStore = Store<RoomState, RoomAction>

struct RoomState: Equatable {
    enum Presentation: Equatable, Identifiable {
        var id: Self {
            self
        }

        case newFurniture
    }

    init(room: Room) {
        self.room = room
    }

    static func new() -> Self {
        .init(room: Room(id: UUID(), name: "New Room"))
    }

    var room: Room
    var selection: Identified<Furniture.ID, FurnitureState>?
    var presentation: Presentation?
    var recentSelectionID: Furniture.ID?
}

enum RoomAction: Equatable {
    case form(BindingAction<RoomState>)
    case setNavigation(selection: Furniture.ID?)
    case furniture(action: FurnitureAction)
    case setPresentation(RoomState.Presentation?)
    // operations
    case didDeselect(Identified<Furniture.ID, FurnitureState>?)
}

struct RoomEnvironment {}

typealias RoomReducer = Reducer<RoomState, RoomAction, RoomEnvironment>

extension RoomReducer {
    static let pure = Reducer { state, action, _ in
        switch action {
        case .form:
            return .none
        case .setNavigation(selection: .none):
            let oldSelection = state.selection
            state.selection = nil
            return .init(value: .didDeselect(oldSelection))
        case let .setNavigation(selection: .some(id)):
            let oldSelection = state.selection
            if let index = state.room.furniture.firstIndex(where: { $0.id == id }) {
                let furniture = state.room.furniture[index]
                state.selection = Identified(FurnitureState(furniture: furniture), id: id)
            }
            return .init(value: .didDeselect(oldSelection))
        case .furniture:
            return .none
        case .setPresentation(nil):
            defer {
                state.presentation = nil
            }

            if state.presentation == .newFurniture, let selection = state.selection {
                state.room.furniture.append(selection.furniture)
            }

            return .init(value: .setNavigation(selection: state.recentSelectionID))

        case let .setPresentation(presentation):
            state.recentSelectionID = state.selection?.id

            if presentation == .newFurniture {
                let newState = FurnitureState(furniture: Furniture(id: UUID(), name: "New Furniture"))
                state.selection = Identified(newState, id: newState.furniture.id)
            }

            state.presentation = presentation
            return .none
        case let .didDeselect(oldSelection):
            if let selection = oldSelection {
                if let index = state.room.furniture.firstIndex(where: { $0.id == selection.id }) {
                    state.room.furniture[index] = selection.furniture
                }
            }
            return .none
        }
    }.binding(action: /RoomAction.form)

    static let roomReducer = Reducer.combine(
        FurnitureReducer
            .furnitureReducer
            .pullback(
                state: \Identified.value,
                action: .self,
                environment: { $0 }
            )
            .optional()
            .pullback(
                state: \.selection,
                action: /RoomAction.furniture(action:),
                environment: { _ in FurnitureEnvironment() }
            ),
        pure
    )
}
