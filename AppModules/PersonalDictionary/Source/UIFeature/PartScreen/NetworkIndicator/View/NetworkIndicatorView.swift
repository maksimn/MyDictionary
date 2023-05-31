//
//  NetworkIndicatorView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct NetworkIndicatorView: View {

    let store: StoreOf<NetworkIndicator>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                if viewStore.isVisible {
                    ProgressView()
                }
            }
            .onAppear {
                viewStore.send(.initialize)
            }
        }
    }
}
