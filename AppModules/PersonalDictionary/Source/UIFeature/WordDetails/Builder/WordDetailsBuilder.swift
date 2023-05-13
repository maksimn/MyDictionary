//
//  NewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct WordDetailsBuilder {

    private let store: StoreOf<WordDetails>

    init(store: StoreOf<WordDetails>) {
        self.store = store
    }

    func build() -> some View {
        WordDetailsView(
            store: store,
            theme: Theme.data
        )
    }
}
