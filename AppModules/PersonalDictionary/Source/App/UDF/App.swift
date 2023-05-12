//
//  App.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 12.05.2023.
//

import ComposableArchitecture

struct App: ReducerProtocol {

    let langRepository: LangRepository
    let loadSavedMainWordListEffect: Effect
    let createWordEffect: WordEffect
    let deleteWordEffect: WordEffect

    struct State: Equatable {
        var mainWordList = MainWordList.State()
    }

    enum Action {
        case mainWordList(MainWordList.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.mainWordList, action: /Action.mainWordList) {
            MainWordList(langRepository: langRepository)
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .mainWordList(let action):
            return reduceInto(&state, mainWordList: action)
        }
    }

    private func reduceInto(_ state: inout State, mainWordList action: MainWordList.Action) -> EffectTask<Action> {
        switch action {
        case .loadSavedMainWordList:
            return loadSavedMainWordListEffect.run()

        case .newWord(.sendNewWord(let word)):
            guard let word = word else { break }

            return createWordEffect.run(word)

        case .delete(let word):
            return deleteWordEffect.run(word)

        default:
            break
        }

        return .none
    }
}
