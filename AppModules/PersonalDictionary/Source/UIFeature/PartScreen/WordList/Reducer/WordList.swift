//
//  WordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct WordList: ReducerProtocol {

    let deleteWordDbWorker: DeleteWordDbWorker

    struct State: Equatable {
        var wordList: IdentifiedArrayOf<WordVO> = []
    }

    enum Action {
        case wordUpdated(WordVO)
        case delete(Word.Id)
        case deleteWordResult(TaskResult<Word.Id>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .wordUpdated(let word):
            guard let position = state.wordList.firstIndex(where: { $0._id == word._id }) else { break }

            state.wordList[position] = word

        case .delete(let wordId):
            guard let position = state.wordList.firstIndex(where: { $0._id == wordId }) else { break }

            state.wordList.remove(at: position)

            return .run { send in
                await send(.deleteWordResult(TaskResult { try await deleteWordDbWorker.delete(wordId: wordId) }))
            }

        default:
            break
        }

        return .none
    }
}
