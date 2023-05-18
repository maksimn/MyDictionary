//
//  MainScreen.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import CoreModule

struct MainScreen: ReducerProtocol {

    let config: Config

    struct State: Equatable {
        var mainWordList = MainWordList.State()
        var linkToNewWord = LinkToNewWord.State()
    }

    enum Action {
        case mainWordList(MainWordList.Action)
        case linkToNewWord(LinkToNewWord.Action)
    }

    var body: some ReducerProtocolOf<MainScreen> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.mainWordList, action: /Action.mainWordList) {
            MainWordList(
                wordListFetcher: WordListFetcherImpl(realmFactory: realmFactory()),
                createWordEffect: CreateWordEffectImpl(
                    createWordDbWorker: CreateWordDbWorkerImpl(realmFactory: realmFactory()),
                    updateWordDbWorker: UpdateWordDbWorkerImpl(realmFactory: realmFactory()),
                    dictionaryService: PonsDictionaryService(
                        secret: config.translationApiKey,
                        httpClient: LoggableHttpClient(logger: logger()),
                        decoder: PonsDictionaryEntryDecoder()
                    ),
                    logger: logger()
                )
            )
        }
        Scope(state: \.linkToNewWord, action: /Action.linkToNewWord) {
            LinkToNewWord(config: config)
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .linkToNewWord(.newWord(.sendNewWord(let word))):
            guard let word = word else { break }

            return .send(.mainWordList(.createWord(word)))

        default:
            break
        }

        return .none
    }

    private func logger() -> Logger {
        LoggerImpl(category: "MainWordList")
    }

    private func realmFactory() -> RealmFactory {
        RealmFactoryImpl(logger: logger())
    }
}
