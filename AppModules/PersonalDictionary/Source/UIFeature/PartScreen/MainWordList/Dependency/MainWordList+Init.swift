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
        let ponsDictionaryService = PonsDictionaryService(
            secret: translationApiKey,
            httpClient: CountableHttpClient(),
            decoder: PonsDictionaryEntryDecoder()
        )

        self.wordListFetcher = WordListFetcherImpl()
        self.createWordEffect = CreateWordEffectImpl(
            createWordDbWorker: CreateWordDbWorkerImpl(),
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            dictionaryService: ErrorSendableDictionaryService(
                dictionaryService: ponsDictionaryService,
                errorMessageSender: ErrorMessageStreamImpl.instance,
                messageTemplate: "Failed to get data about the word '%@'"
            ),
            logger: logger()
        )
    }
}
