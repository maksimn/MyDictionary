//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

protocol DictionaryService {

    func fetchDictionaryEntry(for word: Word) async throws -> Word
}
