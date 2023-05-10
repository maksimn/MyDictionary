//
//  MainWordList.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import CoreModule

protocol MainWordListEffect {

    func run() -> EffectTask<MainWordList.Action>
}

protocol WordEffect {

    func run(_ word: Word) -> EffectTask<MainWordList.Action>
}

struct LoadSavedMainWordListEffect: MainWordListEffect {

    let wordListRepository: WordListRepository
    let logger: Logger

    func run() -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                let wordList = try wordListRepository.wordList()

                await send(.savedWordListLoaded(wordList))
            } catch {
                logger.errorWithContext(error)
            }
        }
    }
}

struct CreateWordEffect: WordEffect {

    let wordListRepository: WordListRepository
    let logger: Logger

    func run(_ word: Word) -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                logger.debug("Create word start: \(word) ")

                try await wordListRepository.create(word: word)

                logger.debug("Create word success: \(word) ")
            } catch {
                logger.log("Create word error, word: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }
}

struct DeleteWordEffect: WordEffect {

    let wordListRepository: WordListRepository
    let logger: Logger

    func run(_ word: Word) -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                logger.debug("Delete word start: \(word) ")

                try await wordListRepository.delete(word: word)

                logger.debug("Delete word success: \(word) ")
            } catch {
                logger.log("Delete word error, word: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }
}
