//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainWordListBuilder {

    private let config: Config

    private let store: StoreOf<MainWordList>

    init(config: Config) {
        let lang1 = config.langData.allLangs[0]
        let lang2 = config.langData.allLangs[1]
        let words = [
            "Banana", "Potato", "Tomato",
            "Banana", "Potato", "Tomato",
            "Banana", "Potato", "Tomato",
            "Banana", "Potato", "Tomato"
        ]
        self.config = config
        self.store = Store(
            initialState: .init(
                wordList: IdentifiedArrayOf(uniqueElements: words.map {
                    IdentifiedWord(word: Word(text: $0, sourceLang: lang1, targetLang: lang2))
                })
            ),
            reducer: MainWordList(
                langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard, data: config.langData)
            )._printChanges()
        )
    }

    func build() -> some View {
        MainWordListView(
            config: config,
            store: store,
            theme: Theme.data
        )
    }
}
