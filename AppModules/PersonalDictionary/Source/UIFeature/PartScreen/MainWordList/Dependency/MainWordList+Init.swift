//
//  MainWordList+Init.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule

private func logger() -> Logger {
    LoggerImpl(category: "MainWordList")
}

extension MainWordList {

    init(translationApiKey: String) {
        self.wordListFetcher = WordListFetcherImpl()
        self.createWordEffect = CreateWordEffectImpl(
            createWordDbWorker: CreateWordDbWorkerImpl(),
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            dictionaryService: PonsDictionaryService(
                secret: translationApiKey,
                httpClient: LoggableHttpClient(logger: logger()),
                decoder: PonsDictionaryEntryDecoder()
            ),
            logger: logger()
        )
    }
}
