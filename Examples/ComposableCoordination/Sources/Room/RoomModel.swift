//
//  RoomModel.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import Foundation

struct Room: Equatable, Codable, Identifiable {
    var id: UUID
    var name: String
    var furniture: [Furniture] = []
}

let sampleRoom = Room(
    id: UUID(),
    name: "Bedroom",
    furniture: [
        Furniture(id: UUID(), name: "Bed"),
        Furniture(id: UUID(), name: "Closet")
    ]
)
