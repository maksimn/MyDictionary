//
//  CreateWordEffect.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import CoreModule

protocol CreateWordEffect {

    func run(_ word: Word) async throws -> Word
}

struct CreateWordEffectImpl: CreateWordEffect {

    let createWordDbWorker: CreateWordDbWorker
    let updateWordDbWorker: UpdateWordDbWorker
    let dictionaryService: DictionaryService
    let logger: Logger

    func run(_ word: Word) async throws -> Word {
        do {
            logger.debug("Create word effect start: \(word)")

            try await dbCreateWord(word)
            let updatedWord = try await fetchAndDecodeTranslationData(word)
            try await dbUpdateWord(updatedWord)

            logger.debug("Create word effect success: \(updatedWord)")

            return updatedWord
        } catch {
            logger.log("Create word effect error: \(word)", level: .error)
            throw error
        }
    }

    private func dbCreateWord(_ word: Word) async throws {
        logger.debug("Create word in the device DB start: \(word)")

        try await createWordDbWorker.create(word: word)

        logger.debug("Create word in the device DB success: \(word)")
    }

    private func fetchAndDecodeTranslationData(_ word: Word) async throws -> Word {
        logger.debug("Fetch and decode translation from the remote API start, word = \(word)")

        let updatedWord = try await dictionaryService.fetchDictionaryEntry(for: word)

        logger.debug("Fetch and decode translation from the remote API success, word = \(updatedWord)")

        return updatedWord
    }

    private func dbUpdateWord(_ word: Word) async throws {
        logger.debug("Update word in the device DB start: \(word)")

        try await updateWordDbWorker.update(word: word)

        logger.debug("Update word in the device DB success: \(word)")
    }
}
