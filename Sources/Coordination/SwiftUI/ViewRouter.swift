//
//  ViewRouter.swift
//
//
//  Created by Daniel Moro on 3.2.21..
//

import SwiftUI

// swiftlint:disable type_name

public protocol ViewRouter {
    associatedtype V1: View
    func home() -> V1
}

// swiftlint:enable type_name
