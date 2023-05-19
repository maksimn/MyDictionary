//
//  Word.swift
//  
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
        sourceLang: Lang = .init(id: .init(raw: -1), name: "", shortName: ""),
        targetLang: Lang = .init(id: .init(raw: -1), name: "", shortName: ""),
        isFavorite: Bool = false,
        createdAt: Int = Date().integer
    ) {
        self.id = id
        self.text = text
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt))
        """
    }
}
