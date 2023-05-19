//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct WordDetailsVO: Equatable {
    var title: String = ""
    var entry: DictionaryEntry = []
}

struct WordDetails: ReducerProtocol {

    let id: Word.Id
    let fetcher: WordDetailsFetcher

    struct State: Equatable {
        var details = WordDetailsVO()
    }

    enum Action {
        case loadWordDetails
        case loadWordDetailsResult(TaskResult<WordDetailsVO>)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadWordDetails:
            return .run { send in
                await send(.loadWordDetailsResult(TaskResult { try fetcher.wordDetails(id) }))
            }

        case .loadWordDetailsResult(.success(let details)):
            state.details = details

        default:
            break
        }

        return .none
    }
}
