//
//  MainWordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct MainWordList: ReducerProtocol {

    private let loadSavedMainWordListEffect: MainWordListEffect
    private let createWordEffect: WordEffect
    private let deleteWordEffect: WordEffect
    private let langRepository: LangRepository

    init(loadSavedMainWordListEffect: MainWordListEffect,
         createWordEffect: WordEffect,
         deleteWordEffect: WordEffect,
         langRepository: LangRepository) {
        self.loadSavedMainWordListEffect = loadSavedMainWordListEffect
        self.createWordEffect = createWordEffect
        self.deleteWordEffect = deleteWordEffect
        self.langRepository = langRepository
    }

    struct State: Equatable {
        var wordList: IdentifiedArrayOf<IdentifiedWord> = []
        var newWord: NewWord.State?
    }

    enum Action {
        case loadSavedMainWordList
        case savedWordListLoaded([Word])
        case showNewWordView
        case wordUpdated(Word)
        case delete(Word)
        case newWord(NewWord.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        .ifLet(\.newWord, action: /Action.newWord) {
            NewWord(langRepository: langRepository)
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loadSavedMainWordList:
            return loadSavedMainWordListEffect.run()

        case .savedWordListLoaded(let wordList):
            state.wordList = IdentifiedArrayOf(
                uniqueElements: wordList.map { IdentifiedWord(word: $0) }
            )

        case .showNewWordView:
            state.newWord = newWordInitialState()

        case .newWord(.sendNewWord(let word)):
            guard let word = word else { break }

            state.wordList.insert(IdentifiedWord(word: word), at: 0)

            return createWordEffect.run(word)

        case .wordUpdated(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList[position] = IdentifiedWord(word: word)

        case .delete(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList.remove(at: position)

            return deleteWordEffect.run(word)

        default:
            break
        }

        return .none
    }

    private func newWordInitialState() -> NewWord.State {
        .init(
            text: "",
            sourceLang: langRepository.sourceLang(),
            targetLang: langRepository.targetLang(),
            langPicker: .init(
                lang: langRepository.sourceLang(),
                langType: .source,
                isHidden: true
            )
        )
    }
}

struct IdentifiedWord: Equatable, Identifiable {
    var word: Word
    var id: String {
        word.id.raw
    }
}
