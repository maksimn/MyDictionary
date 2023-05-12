//
//  NewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import CoreModule
import SwiftUI

final class NewWordBuilder: SwiftViewBuilder {

    private let config: Config

    private let store: StoreOf<NewWord>

    init(config: Config, store: StoreOf<NewWord>) {
        self.config = config
        self.store = store
    }

    func build() -> some View {
        NewWordView(
            store: store,
            langPickerBuilder: LangPickerBuilder(
                store: store.scope(state: \.langPicker, action: NewWord.Action.langPicker),
                allLangs: config.langData.allLangs
            ),
            theme: Theme.data
        )
    }
}
