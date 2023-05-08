//
//  MainWordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import Foundation

struct MainWordList: ReducerProtocol {

    private let config: Config

    init(config: Config) {
        self.config = config
    }

    struct State: Equatable {
        var wordList: IdentifiedArrayOf<IdentifiedWord> = []
        var newWord: NewWord.State?
    }

    enum Action {
        case delete(Word)
        case newWord(NewWord.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        .ifLet(\.newWord, action: /Action.newWord) {
            NewWord(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard, data: config.langData))
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .newWord(.newWord):
            guard let word = state.newWord?.newWord else { break }

            state.wordList.insert(IdentifiedWord(word: word), at: 0)

        case .delete(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList.remove(at: position)

        default:
            break
        }

        return .none
    }
}

struct IdentifiedWord: Equatable, Identifiable {
    var word: Word
    var id: String {
        "\(word.id.raw)-\(word.updatedAt)"
    }
}