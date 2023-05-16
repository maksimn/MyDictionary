//
//  VocabEntry.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct WordDetails: ReducerProtocol {

    struct State: Equatable {
        var word: Word
    }

    enum Action { }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}
