//
//  MainWordList+Init.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule

extension MainWordList {

    init(translationApiKey: String) {
        let ponsDictionaryService = PonsDictionaryService(
            secret: translationApiKey,
            httpClient: HttpClientAdapterImpl(),
            decoder: PonsDictionaryEntryDecoder()
        )
        let countablePonsDictionaryService = CountableDictionaryService(
            dictionaryService: ponsDictionaryService,
            mutator: ActivityCount.instance
        )

        self.wordListFetcher = WordListFetcherImpl()
        self.createWordEffect = CreateWordEffectImpl(
            createWordDbWorker: CreateWordDbWorkerImpl(),
            updateWordDbWorker: UpdateWordDbWorkerImpl(),
            dictionaryService: ErrorSendableDictionaryService(
                dictionaryService: countablePonsDictionaryService,
                errorMessageSender: ErrorMessageStreamImpl.instance,
                messageTemplate: "Failed to get data about the word '%@'"
            ),
            logger: LoggerImpl(category: "MainWordList")
        )
    }
}
