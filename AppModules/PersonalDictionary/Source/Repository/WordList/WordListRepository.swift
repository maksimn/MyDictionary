//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol WordListRepository {

    func wordList() throws -> [Word]

    func create(word: Word) async throws
}
