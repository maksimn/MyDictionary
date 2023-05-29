//
//  MainWordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct MainWordList: ReducerProtocol {

    let wordListFetcher: WordListFetcher
    let createWordEffect: CreateWordEffect

    struct State: Equatable {
        var wordList = WordList.State()
    }

    enum Action {
        case loadSavedMainWordList
        case loadSavedMainWordListResult(TaskResult<[WordVO]>)
        case createWord(Word)
        case createWordResult(TaskResult<Word>)
        case wordList(WordList.Action)
    }

    var body: some ReducerProtocolOf<MainWordList> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.wordList, action: /Action.wordList) {
            WordList(
                toggleWordIsFavoriteEffect: ToggleWordIsFavoriteEffectImpl(
                    findWordDbWorker: FindWordDbWorkerImpl(),
                    updateWordDbWorker: UpdateWordDbWorkerImpl()
                ),
                deleteWordDbWorker: DeleteWordDbWorkerImpl()
            )
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadSavedMainWordList:
            return .run { send in
                await send(.loadSavedMainWordListResult(
                    TaskResult { try wordListFetcher.wordList().map { WordVO($0) } })
                )
            }

        case .loadSavedMainWordListResult(.success(let wordList)):
            state.wordList.wordList = IdentifiedArrayOf(uniqueElements: wordList)

        case .createWord(let word):
            state.wordList.wordList.insert(WordVO(word), at: 0)

            return .run { send in
                await send(.createWordResult(TaskResult { try await createWordEffect.run(word) }))
            }

        case .createWordResult(.success(let word)):
            return .send(.wordList(.wordUpdated(WordVO(word))))

        default:
            break
        }

        return .none
    }
}
