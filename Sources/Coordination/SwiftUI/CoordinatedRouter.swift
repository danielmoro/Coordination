//
//  CoordinatedRouter.swift
//
//
//  Created by Daniel Moro on 7.2.21..
//

public protocol CoordinatedRouter: DismissableRouter {
    var terminateCoordination: () -> Void { get set }
}

public extension CoordinatedRouter {
    func dismiss() {
        onDismiss?()
        terminateCoordination()
    }
}
