//
//  MainWordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct MainWordList: ReducerProtocol {

    private let langRepository: LangRepository

    init(langRepository: LangRepository) {
        self.langRepository = langRepository
    }

    struct State: Equatable {
        var wordList: IdentifiedArrayOf<IdentifiedWord> = []
        var newWord: NewWord.State?
        var wordDetails: WordDetails.State?
    }

    enum Action {
        case loadSavedMainWordList
        case savedWordListLoaded([Word])
        case showNewWordView
        case showWordDetails(Word)
        case wordUpdated(Word)
        case delete(Word)
        case newWord(NewWord.Action)
        case wordDetails(WordDetails.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        .ifLet(\.newWord, action: /Action.newWord) {
            NewWord(langRepository: langRepository)
        }
        .ifLet(\.wordDetails, action: /Action.wordDetails) {
            WordDetails()
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .savedWordListLoaded(let wordList):
            state.wordList = IdentifiedArrayOf(
                uniqueElements: wordList.map { IdentifiedWord(word: $0) }
            )

        case .showNewWordView:
            state.newWord = newWordInitialState()

        case .showWordDetails(let word):
            state.wordDetails = .init(word: word)

        case .newWord(.sendNewWord(let word)):
            guard let word = word else { break }

            state.wordList.insert(IdentifiedWord(word: word), at: 0)

        case .wordUpdated(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList[position] = IdentifiedWord(word: word)

        case .delete(let word):
            guard let position = state.wordList.firstIndex(where: { $0.word.id == word.id }) else { break }

            state.wordList.remove(at: position)

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
