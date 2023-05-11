//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

protocol TranslationService {

    func fetchTranslation(for word: Word) async throws -> Word
}
