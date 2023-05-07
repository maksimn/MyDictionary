//
//  NewWordBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import Foundation
import SwiftUI

final class NewWordBuilder {

    private let config: Config

    private lazy var store = {
        let langRepository = LangRepositoryImpl(
            userDefaults: UserDefaults.standard,
            data: config.langData
        )
        let initialState = NewWord.State(
            text: "",
            sourceLang: langRepository.sourceLang(),
            targetLang: langRepository.targetLang(),
            langPicker: .init(
                lang: langRepository.sourceLang(),
                langType: .source,
                isHidden: true
            )
        )

        return Store(
            initialState: initialState,
            reducer: NewWord(langRepository: langRepository)._printChanges()
        )
    }()

    init(config: Config) {
        self.config = config
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
