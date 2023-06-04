//
//  CountableDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 06.05.2023.
//

struct CountableDictionaryService: DictionaryService {

    let dictionaryService: DictionaryService
    let mutator: ActivityCountMutator

    func fetchDictionaryEntry(for word: Word) async throws -> Word {
        mutator.increment()

        do {
            let resultWord = try await dictionaryService.fetchDictionaryEntry(for: word)

            mutator.decrement()

            return resultWord
        } catch {
            mutator.decrement()
            throw error
        }
    }
}
