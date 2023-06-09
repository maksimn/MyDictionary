//
//  Word.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule
import Foundation

typealias DictionaryEntry = [String]

struct Word: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    let id: Id

    let text: String

    var dictionaryEntry: DictionaryEntry = [] 

    let sourceLang: Lang

    let targetLang: Lang

    var isFavorite: Bool

    let createdAt: Int

    init(
        id: Id = Id(raw: UUID().uuidString),
        text: String = "",
        dictionaryEntry: DictionaryEntry = [],
        sourceLang: Lang = .init(id: .init(raw: -1), name: "", shortName: ""),
        targetLang: Lang = .init(id: .init(raw: -1), name: "", shortName: ""),
        isFavorite: Bool = false,
        createdAt: Int = Date().integer
    ) {
        self.id = id
        self.text = text
        self.dictionaryEntry = dictionaryEntry
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        dictionaryEntry: \(dictionaryEntryDescription), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt))
        """
    }

    private var dictionaryEntryDescription: String {
        let count = dictionaryEntry.count

        return dictionaryEntry.isEmpty ?
            "<empty>" :
            "[\(dictionaryEntry.first ?? "")\(count > 1 ? ", ...\(count - 1) values" : "")]"
    }
}

struct WordVO: Equatable, Identifiable {
    let _id: Word.Id
    let text: String
    let translation: String
    let sourceLang: String
    let targetLang: String
    var isFavorite: Bool

    init(_ word: Word) {
        _id = word.id
        text = word.text
        translation = word.dictionaryEntry.first ?? ""
        sourceLang = word.sourceLang.shortName
        targetLang = word.targetLang.shortName
        isFavorite = word.isFavorite
    }

    var id: String {
        _id.raw
    }
}
