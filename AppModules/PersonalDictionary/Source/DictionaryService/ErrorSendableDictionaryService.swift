//
//  ErrorSendableDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 02.06.2023.
//

struct ErrorSendableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let errorMessageSender: ErrorMessageSender
    let messageTemplate: String

    func fetchDictionaryEntry(for word: Word) async throws -> Word {
        do {
            return try await dictionaryService.fetchDictionaryEntry(for: word)
        } catch {
            let message = String(format: messageTemplate, word.text)

            errorMessageSender.send(.error(message))
            throw error
        }
    }
}
