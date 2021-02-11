//
//  HouseModel.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

struct House: Equatable, Codable {
    var name: String
    var notes: String?
    var rooms: [Room] = []
}
