//
//  App.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 12.05.2023.
//

import ComposableArchitecture
import Foundation

struct App: ReducerProtocol {

    let config: Config
    let wordListFetcher: WordListFetcher
    let createWordEffect: CreateWordEffect
    let deleteWordDbWorker: DeleteWordDbWorker

    struct State: Equatable {
        var mainWordList = MainWordList.State()
    }

    enum Action {
        case loadSavedMainWordListResult(TaskResult<[Word]>)
        case createWordResult(TaskResult<Word>)
        case deleteWordResult(TaskResult<Word>)
        case mainWordList(MainWordList.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.mainWordList, action: /Action.mainWordList) {
            MainWordList(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard, data: config.langData))
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .mainWordList(let action):
            return reduceInto(&state, mainWordList: action)

        case .loadSavedMainWordListResult(.success(let wordList)):
            return .send(.mainWordList(.savedWordListLoaded(wordList)))

        case .createWordResult(.success(let word)):
            return .send(.mainWordList(.wordUpdated(word)))

        default:
            break
        }

        return .none
    }

    private func reduceInto(_ state: inout State, mainWordList action: MainWordList.Action) -> EffectTask<Action> {
        switch action {
        case .loadSavedMainWordList:
            return .run { send in
                await send(.loadSavedMainWordListResult(TaskResult { try wordListFetcher.wordList() }))
            }

        case .newWord(.sendNewWord(let word)):
            guard let word = word else { break }

            return .run { send in
                await send(.createWordResult(TaskResult { try await createWordEffect.run(word) }))
            }

        case .delete(let word):
            return .run { send in
                await send(.deleteWordResult(TaskResult { try await deleteWordDbWorker.delete(word: word) }))
            }

        default:
            break
        }

        return .none
    }
}
