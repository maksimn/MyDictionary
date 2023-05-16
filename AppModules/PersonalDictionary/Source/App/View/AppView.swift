//
//  AppView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import CoreModule
import ComposableArchitecture
import SwiftUI

private let config = ConfigFactory().config()
private let logger = LoggerImpl(category: "App")
private let realmFactory = RealmFactoryImpl(logger: logger)

private let app = App(
    config: config,
    wordListFetcher: WordListFetcherImpl(realmFactory: realmFactory),
    createWordEffect: CreateWordEffectImpl(
        createWordDbWorker: CreateWordDbWorkerImpl(realmFactory: realmFactory),
        updateWordDbWorker: UpdateWordDbWorkerImpl(realmFactory: realmFactory),
        dictionaryService: PonsDictionaryService(
            secret: config.translationApiKey,
            httpClient: LoggableHttpClient(logger: logger),
            decoder: PonsDictionaryEntryDecoder()
        ),
        logger: logger
    ),
    deleteWordDbWorker: DeleteWordDbWorkerImpl(realmFactory: realmFactory)
)

private let store = Store(
    initialState: .init(),
    reducer: app._printChanges()
)

public struct AppView: View {

    public init() { }

    public var body: some View {
        MainWordListView(
            config: config,
            store: store.scope(state: \.mainWordList, action: App.Action.mainWordList),
            theme: Theme.data
        )
    }
}
