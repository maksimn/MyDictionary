//
//  LangPicker.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct LangPicker: ReducerProtocol {

    struct State: Equatable {
        var lang: Lang
        var langType: LangType
        var isHidden: Bool
    }

    enum Action {
        case show(lang: Lang, langType: LangType)
        case hide
        case langChanged(Lang)
        case none
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .show(let lang, let langType):
            state.lang = lang
            state.langType = langType
            state.isHidden = false

        case .langChanged(let lang):
            state.lang = lang

        case .hide:
            state.isHidden = true

        case .none:
            break
        }

        return .none
    }
}
