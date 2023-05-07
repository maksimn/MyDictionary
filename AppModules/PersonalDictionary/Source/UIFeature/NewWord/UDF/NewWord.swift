//
//  NewWord.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct NewWord: ReducerProtocol {

    private let langRepository: LangRepository

    init(langRepository: LangRepository) {
        self.langRepository = langRepository
    }

    struct State: Equatable {
        var text: String
        var sourceLang: Lang
        var targetLang: Lang
        var langPicker: LangPicker.State

        var newWord: Word? {
            let word = Word(
                text: text.trimmingCharacters(in: .whitespacesAndNewlines),
                sourceLang: sourceLang,
                targetLang: targetLang
            )

            guard !word.text.isEmpty else { return nil }

            return word
        }
    }

    enum Action {
        case textChanged(String)
        case newWord
        case langPicker(LangPicker.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(state: &state, action: action)
        }
        Scope(state: \.langPicker, action: /Action.langPicker) {
            LangPicker()
        }
    }

    private func reduceInto(state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .textChanged(let text):
            state.text = text

        case .langPicker(let action):
            return reduceInto(state: &state, langPicker: action)

        default:
            break
        }

        return .none
    }

    private func reduceInto(state: inout State, langPicker action: LangPicker.Action) -> EffectTask<Action> {
        switch action {
        case .hide:
            if state.langPicker.langType == .source {
                state.sourceLang = state.langPicker.lang

                langRepository.set(sourceLang: state.sourceLang)
            } else {
                state.targetLang = state.langPicker.lang

                langRepository.set(targetLang: state.targetLang)
            }

        default:
            break
        }

        return .none
    }
}
