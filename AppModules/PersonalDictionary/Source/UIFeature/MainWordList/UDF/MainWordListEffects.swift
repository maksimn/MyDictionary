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

    let wordListFetcher: WordListFetcher
    let logger: Logger

    func run() -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                let wordList = try wordListFetcher.wordList()

                await send(.savedWordListLoaded(wordList))
            } catch {
                logger.errorWithContext(error)
            }
        }
    }
}

struct CreateWordEffect: WordEffect {

    let createWordDbPerformer: CreateWordDbPerformer
    let updateWordDbPerformer: UpdateWordDbPerformer
    let translationService: TranslationService
    let logger: Logger

    func run(_ word: Word) -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                logger.debug("Create word effect start: \(word)")
                logger.debug("Create word in the device DB start: \(word)")

                try await createWordDbPerformer.create(word: word)

                logger.debug("Create word in the device DB success: \(word)")

                logger.debug("Fetch translation from the remote API start, word = \(word)")

                let updatedWord = try await translationService.fetchTranslation(for: word)

                logger.debug("Fetch translation from the remote API success, word = \(updatedWord)")

                await send(.wordUpdated(updatedWord))

                logger.debug("Update word in the device DB start: \(updatedWord)")

                try await updateWordDbPerformer.update(word: updatedWord)

                logger.debug("Update word in the device DB success: \(updatedWord)")
                logger.debug("Create word effect success: \(updatedWord)")
            } catch {
                logger.log("Create word effect error: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }
}

struct DeleteWordEffect: WordEffect {

    let dbPerformer: DeleteWordDbPerformer
    let logger: Logger

    func run(_ word: Word) -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                logger.debug("Delete word start: \(word) ")

                try await dbPerformer.delete(word: word)

                logger.debug("Delete word success: \(word) ")
            } catch {
                logger.log("Delete word error, word: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }
}
