//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import CoreModule
import SwiftUI

struct MainWordListBuilder {

    private let config: Config

    private let store: StoreOf<MainWordList>

    init(config: Config) {
        let logger = LoggerImpl(category: "MainWordList")
        let wordListRepository = WordListRepositoryImpl(logger: logger)
        let loadSavedMainWordListEffect = LoadSavedMainWordListEffect(
            wordListRepository: wordListRepository,
            logger: logger
        )
        let createWordEffect = CreateWordEffect(wordListRepository: wordListRepository, logger: logger)
        self.config = config
        self.store = Store(
            initialState: .init(),
            reducer: MainWordList(
                loadSavedMainWordListEffect: loadSavedMainWordListEffect,
                createWordEffect: createWordEffect,
                deleteWordEffect: DeleteWordEffect(wordListRepository: wordListRepository, logger: logger),
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
