//
//  DemoSwiftUICoordinator.swift
//
//
//  Created by Daniel Moro on 19.1.21..
//

import SwiftUI

class DemoSwiftUICoordinator: Coordinator {
    var children: [Coordinator] = []

    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let mainView = EmptyView()
        router.setRoot(mainView)
    }

    func dismiss(animated: Bool) {
        router.dismiss()
    }

    var router: Router = Router(isPresented: .constant(false))
}
