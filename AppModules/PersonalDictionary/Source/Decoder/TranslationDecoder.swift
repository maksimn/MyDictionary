//
//  TranslationDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

protocol TranslationDecoder {

    func decodeTranslation(for word: Word) async throws -> String
}
