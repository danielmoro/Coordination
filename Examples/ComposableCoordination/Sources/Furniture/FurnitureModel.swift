//
//  FurnitureModel.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import Foundation

struct Furniture: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var notes: String = ""
}
