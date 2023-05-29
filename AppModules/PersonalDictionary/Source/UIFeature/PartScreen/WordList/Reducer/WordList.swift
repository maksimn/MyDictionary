//
//  WordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct WordList: ReducerProtocol {

    let toggleWordIsFavoriteEffect: ToggleWordIsFavoriteEffect
    let deleteWordDbWorker: DeleteWordDbWorker

    struct State: Equatable {
        var wordList: IdentifiedArrayOf<WordVO> = []

        func findIndexBy(id: Word.Id) -> IdentifiedArrayOf<WordVO>.Index? {
            wordList.firstIndex(where: { $0._id == id })
        }
    }

    enum Action {
        case wordUpdated(WordVO)
        case toggleIsFavorite(WordVO)
        case toggleIsFavoriteResult(TaskResult<Word>)
        case delete(Word.Id)
        case deleteWordResult(TaskResult<Word.Id>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .wordUpdated(let word):
            guard let position = state.findIndexBy(id: word._id) else { break }

            state.wordList[position] = word

        case .delete(let wordId):
            guard let position = state.findIndexBy(id: wordId) else { break }

            state.wordList.remove(at: position)

            return .run { send in
                await send(.deleteWordResult(TaskResult { try await deleteWordDbWorker.delete(wordId: wordId) }))
            }

        case .toggleIsFavorite(let word):
            return .run { send in
                await send(.toggleIsFavoriteResult(TaskResult { try await toggleWordIsFavoriteEffect.run(word._id) }))
            }

        case .toggleIsFavoriteResult(.success(let word)):
            guard let position = state.findIndexBy(id: word.id) else { break }

            state.wordList[position].isFavorite.toggle()

        default:
            break
        }

        return .none
    }
}
