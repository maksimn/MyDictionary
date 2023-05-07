//
//  Word.swift
//  
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import CoreModule
import Foundation

struct Word: Equatable, Hashable, CustomStringConvertible {

    typealias Id = Tagged<Word, String>

    let id: Id

    let text: String

    var translationApiResponse: TranslationApiResponse?

    let sourceLang: Lang

    let targetLang: Lang

    var isFavorite: Bool

    let createdAt: Int

    init(
        id: Id = Id(raw: UUID().uuidString),
        text: String,
        translationApiResponse: TranslationApiResponse? = nil,
        sourceLang: Lang,
        targetLang: Lang,
        isFavorite: Bool = false,
        createdAt: Int = Date().integer
    ) {
        self.id = id
        self.text = text
        self.translationApiResponse = translationApiResponse
        self.sourceLang = sourceLang
        self.targetLang = targetLang
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }

    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.sourceLang == rhs.sourceLang &&
        lhs.targetLang == rhs.targetLang &&
        lhs.isFavorite == rhs.isFavorite &&
        lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id.raw)
    }

    var description: String {
        """
        Word(id: \(id.raw), \
        text: \(text), \
        translationApiResponse: \(translationApiResponseDescription), \
        sourceLang: \(sourceLang.id.raw), \
        targetLang: \(targetLang.id.raw), \
        isFavorite: \(isFavorite), \
        createdAt: \(createdAt))\n
        """
    }

    private var translationApiResponseDescription: String {
        guard let translationApiResponse = translationApiResponse else { return "nil" }

        return "\(translationApiResponse)"
    }
}

struct TranslationApiResponse {

    let data: Data

    let httpResponseStatusCode: Int
}
