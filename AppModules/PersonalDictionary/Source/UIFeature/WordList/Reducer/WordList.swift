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
        var wordList: IdentifiedArrayOf<IdentifiedWord> = []
    }

    enum Action {
        case wordUpdated(Word)
        case delete(Word)
        case deleteWordResult(TaskResult<Word>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .wordUpdated(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList[position] = IdentifiedWord(word: word)

        case .delete(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList.remove(at: position)

            return .run { send in
                await send(.deleteWordResult(TaskResult { try await deleteWordDbWorker.delete(word: word) }))
            }

        default:
            break
        }

        return .none
    }
}

struct IdentifiedWord: Equatable, Identifiable {
    var word: Word
    var id: String {
        word.id.raw
    }
}
