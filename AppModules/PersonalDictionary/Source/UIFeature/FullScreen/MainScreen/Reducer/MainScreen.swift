//
//  MainScreen.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

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
            MainWordList(translationApiKey: config.translationApiKey)
        }
        Scope(state: \.linkToNewWord, action: /Action.linkToNewWord) {
            LinkToNewWord(langData: config.langData)
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        if case .linkToNewWord(.newWord(.sendNewWord(let word))) = action {
            return .send(.mainWordList(.createWord(word)))
        }

        return .none
    }
}
