//
//  HouseView.swift
//  ComposableCoordination
//
//  Created by Daniel Moro on 31.1.21..
//

import ComposableArchitecture
import Coordination
import SwiftUI

struct HouseView: View {
    let store: Store<HouseState, HouseAction>
    let router: HouseCoordinator
    var body: some View {
        WithViewStore(store) { viewStore in
            form
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            viewStore.send(HouseAction.setPresentation(.newRoom))
                        }, label: {
                            Text("New Room")
                        })
                    }
                }
                .withNavigation(
                    to: router.presentModal(
                        item: viewStore.binding(
                            get: \.presentation,
                            send: HouseAction.setPresentation
                        )
                    )
                )
        }
    }

    var form: some View {
        WithViewStore(store) { viewStore in
            Form {
                TextField("Name", text: viewStore.binding(
                    get: \.house.name,
                    send: HouseAction.houseNameDidChange
                ))

                Section(header: Text("Rooms")) {
                    ForEach(viewStore.house.rooms) { room in

                        Button(action: {
                            viewStore.send(.setNavigation(selection: room.id))
                        }, label: {
                            Text(room.name)
                                .withNavigation(
                                    to: router.navigate(
                                        id: room.id,
                                        item: viewStore.binding(
                                            get: \.selection?.id,
                                            send: HouseAction.setNavigation(selection:)
                                        )
                                    )
                                )
                        })
                    }
                }
            }
        }
    }
}

// struct HouseView_Previews: PreviewProvider {
//    static var previews: some View {
//        HouseView(presenter: <#_#>)
//    }
// }
