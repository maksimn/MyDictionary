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
    let translationDecoder: TranslationDecoder
    let logger: Logger

    func run(_ word: Word) -> EffectTask<MainWordList.Action> {
        .run { send in
            do {
                logger.debug("Create word effect start: \(word)")

                try await dbCreateWord(word)
                let updatedWord = try await fetchTranslationDataAndDecode(word)
                try await dbUpdateWord(updatedWord)

                logger.debug("Create word effect success: \(updatedWord)")

                await send(.wordUpdated(updatedWord))
            } catch {
                logger.log("Create word effect error: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }

    private func dbCreateWord(_ word: Word) async throws {
        logger.debug("Create word in the device DB start: \(word)")

        try await createWordDbPerformer.create(word: word)

        logger.debug("Create word in the device DB success: \(word)")
    }

    private func fetchTranslationDataAndDecode(_ word: Word) async throws -> Word {
        logger.debug("Fetch translation from the remote API start, word = \(word)")

        var updatedWord = try await translationService.fetchTranslationData(for: word)

        logger.debug("Fetch translation from the remote API success, word = \(updatedWord)")
        logger.debug("Decode translation start, word: \(updatedWord)")

        let translation = try await translationDecoder.decodeTranslation(for: updatedWord)

        updatedWord.translation = translation

        logger.debug("Decode translation success, word: \(updatedWord)")

        return updatedWord
    }

    private func dbUpdateWord(_ word: Word) async throws {
        logger.debug("Update word in the device DB start: \(word)")

        try await updateWordDbPerformer.update(word: word)

        logger.debug("Update word in the device DB success: \(word)")
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
