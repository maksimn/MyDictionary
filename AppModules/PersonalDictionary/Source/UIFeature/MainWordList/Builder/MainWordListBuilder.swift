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
        let realmFactory = RealmFactoryImpl(logger: logger)
        self.config = config
        self.store = Store(
            initialState: .init(),
            reducer: MainWordList(
                loadSavedMainWordListEffect: LoadSavedMainWordListEffect(
                    wordListFetcher: WordListFetcherImpl(realmFactory: realmFactory), logger: logger
                ),
                createWordEffect: CreateWordEffect(
                    createWordDbPerformer: CreateWordDbPerformerImpl(realmFactory: realmFactory),
                    updateWordDbPerformer: UpdateWordDbPerformerImpl(realmFactory: realmFactory),
                    translationService: PonsTranslationService(
                        secret: config.translationApiKey,
                        httpClient: LoggableHttpClient(logger: logger)
                    ),
                    translationDecoder: PonsTranslationDecoder(),
                    logger: logger
                ),
                deleteWordEffect: DeleteWordEffect(
                    dbPerformer: DeleteWordDbPerformerImpl(realmFactory: realmFactory), logger: logger
                ),
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
