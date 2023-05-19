//
//  LinkToNewWord.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import Foundation

struct LinkToNewWord: ReducerProtocol {

    let config: Config

    struct State: Equatable {
        var newWord: NewWord.State?
    }

    enum Action {
        case navigateToNewWord
        case newWord(NewWord.Action)
    }

    var body: some ReducerProtocolOf<LinkToNewWord> {
        Reduce { state, action in
            if case .navigateToNewWord = action {
                state.newWord = .init()
            }

            return .none
        }
        .ifLet(\.newWord, action: /Action.newWord) {
            NewWord(langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard, data: config.langData))
        }
    }
}
