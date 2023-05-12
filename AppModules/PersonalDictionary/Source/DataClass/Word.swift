//
//  Word.swift
//  
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule
import Foundation

struct Word: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    let id: Id

    let text: String

    var translation: String {
        didSet {
            onUpdate()
        }
    }

    var translationApiResponse: TranslationApiResponse? {
        didSet {
            onUpdate()
        }
    }

    let sourceLang: Lang

    let targetLang: Lang

    var isFavorite: Bool {
        didSet {
            onUpdate()
        }
    }

    let createdAt: Int

    var updatedAt: Int

    init(
        id: Id = Id(raw: UUID().uuidString),
        text: String,
        translation: String = "",
        translationApiResponse: TranslationApiResponse? = nil,
        sourceLang: Lang,
        targetLang: Lang,
        isFavorite: Bool = false,
        createdAt: Int = Date().integer,
        updatedAt: Int = Date().integer
    ) {
        self.id = id
        self.text = text
        self.translation = translation
        self.translationApiResponse = translationApiResponse
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        translation: \(translation), \
        translationApiResponse: \(translationApiResponse != nil ? "TranslationApiResponse(...)" : "nil"), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt), \
        updatedAt: \(updatedAt))
        """
    }

    private mutating func onUpdate() {
        updatedAt = Date().integer
    }
}

struct TranslationApiResponse: Equatable {

    let url: String

    let data: Data

    let httpResponseStatusCode: Int
}
