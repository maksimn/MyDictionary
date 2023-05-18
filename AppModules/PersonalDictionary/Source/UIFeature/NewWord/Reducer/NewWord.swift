//
//  NewWord.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

private let empty = Lang(id: .init(raw: -1), name: "", shortName: "")
private let emptyPicker = LangPicker.State(lang: empty, langType: .source, isHidden: true)

struct NewWord: ReducerProtocol {

    private let langRepository: LangRepository

    init(langRepository: LangRepository) {
        self.langRepository = langRepository
    }

    struct State: Equatable {
        var text = ""
        var sourceLang = empty
        var targetLang = empty
        var langPicker = emptyPicker
    }

    enum Action {
        case setInitialState
        case textChanged(String)
        case sendNewWord(Word?)
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
        case .setInitialState:
            state = .init(
                text: "",
                sourceLang: langRepository.sourceLang(),
                targetLang: langRepository.targetLang(),
                langPicker: .init(
                    lang: langRepository.sourceLang(),
                    langType: .source,
                    isHidden: true
                )
            )

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
