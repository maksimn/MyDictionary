//
//  CreateWordEffect.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture
import CoreModule

struct CreateWordEffect: WordEffect {

    let createWordDbWorker: CreateWordDbWorker
    let updateWordDbWorker: UpdateWordDbWorker
    let translationService: TranslationService
    let translationDecoder: TranslationDecoder
    let logger: Logger

    func run(_ word: Word) -> AppEffectTask {
        .run { send in
            do {
                logger.debug("Create word effect start: \(word)")

                try await dbCreateWord(word)
                let updatedWord = try await fetchAndDecodeTranslationData(word)
                try await dbUpdateWord(updatedWord)

                logger.debug("Create word effect success: \(updatedWord)")

                await send(.mainWordList(.wordUpdated(updatedWord)))
            } catch {
                logger.log("Create word effect error: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }

    private func dbCreateWord(_ word: Word) async throws {
        logger.debug("Create word in the device DB start: \(word)")

        try await createWordDbWorker.create(word: word)

        logger.debug("Create word in the device DB success: \(word)")
    }

    private func fetchAndDecodeTranslationData(_ word: Word) async throws -> Word {
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

        try await updateWordDbWorker.update(word: word)

        logger.debug("Update word in the device DB success: \(word)")
    }
}
