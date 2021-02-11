//
//  HouseCore.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture

typealias HouseStore = Store<HouseState, HouseAction>

struct HouseState: Equatable {
    var house: House
    var presentation: HousePresentation?
//    var newRoom: RoomState?
    var selection: Identified<Room.ID, RoomState>?
}

enum HouseAction: Equatable {
    // UI
    case houseNameDidChange(String)
    case setPresentation(HousePresentation?)
    case setNavigation(selection: Room.ID?)
    case room(action: RoomAction)
    // operations
    case didDeselect(Identified<Room.ID, RoomState>?)
}

struct HouseEnvironment {}

typealias HouseReducer = Reducer<HouseState, HouseAction, HouseEnvironment>

extension HouseReducer {
    static let pure = Reducer { state, action, _ in
        switch action {
        case let .houseNameDidChange(name):
            state.house.name = name
            return .none
        case .setPresentation(nil):
            defer {
                state.presentation = nil
            }

            if state.presentation == .newRoom, let selection = state.selection {
                state.house.rooms.append(selection.room)
            }

            return .none
        case let .setPresentation(presentation):

            if presentation == .newRoom {
                let newRoomState = RoomState.new()
                state.selection = Identified(newRoomState, id: newRoomState.room.id)
            }

            state.presentation = presentation
            return .none
        case .room:
            return .none
        case .setNavigation(selection: .none):
            let oldSelection = state.selection
            state.selection = nil
            return .init(value: .didDeselect(oldSelection))

        case let .setNavigation(selection: .some(id)):
            let oldSelection = state.selection
            if let room = state.house.rooms.first(where: { $0.id == id }) {
                state.selection = Identified(RoomState(room: room), id: id)
            }
            return .init(value: .didDeselect(oldSelection))

        case let .didDeselect(selection):
            if let selection = selection {
                if let index = state.house.rooms.firstIndex(where: { $0.id == selection.id }) {
                    state.house.rooms[index] = selection.room
                }
            }
        }
        return .none
    }

    static let houseReducer = Reducer.combine(
        RoomReducer
            .roomReducer
            .pullback(
                state: \Identified.value,
                action: .self,
                environment: { $0 }
            )
            .optional()
            .pullback(
                state: \.selection,
                action: /HouseAction.room(action:),
                environment: { _ in RoomEnvironment() }
            ),
        HouseReducer
            .pure
    )
}
