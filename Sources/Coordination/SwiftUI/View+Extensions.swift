//
//  View+Extensions.swift
//
//
//  Created by Daniel Moro on 3.2.21..
//

import SwiftUI

extension View {
    func withNavigation<T: View>(to destination: T) -> some View {
        background(destination)
    }
}
