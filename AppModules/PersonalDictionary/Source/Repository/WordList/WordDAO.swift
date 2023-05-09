//
//  WordDAO.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import Foundation
import RealmSwift

class WordDAO: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var text: String
    @Persisted var translationApiResponse: TranslationApiResponseDAO?
    @Persisted var sourceLang: LangDAO?
    @Persisted var targetLang: LangDAO?
    @Persisted var isFavorite: Bool
    @Persisted var createdAt: Int
    @Persisted var updatedAt: Int

    convenience init(_ word: Word) {
        self.init()
        _id = word.id.raw
        text = word.text

        if let response = word.translationApiResponse {
            translationApiResponse = TranslationApiResponseDAO(response)
        }

        sourceLang = LangDAO(word.sourceLang)
        targetLang = LangDAO(word.targetLang)
        isFavorite = word.isFavorite
        createdAt = word.createdAt
        updatedAt = word.updatedAt
    }
}

class LangDAO: Object {
    @Persisted var _id: Int
    @Persisted var name: String
    @Persisted var shortName: String

    convenience init(_ lang: Lang) {
        self.init()
        _id = lang.id.raw
        name = lang.name
        shortName = lang.shortName
    }
}

class TranslationApiResponseDAO: Object {
    @Persisted var url: String
    @Persisted var data: Data
    @Persisted var httpResponseStatusCode: Int

    convenience init?(_ response: TranslationApiResponse?) {
        self.init()
        guard let response = response else { return }
        url = response.url
        data = response.data
        httpResponseStatusCode = response.httpResponseStatusCode
    }
}

extension Word {

    init?(_ dao: WordDAO) {
        id = .init(raw: dao._id)
        text = dao.text

        if let responseDAO = dao.translationApiResponse {
            translationApiResponse = TranslationApiResponse(responseDAO)
        }

        if let sourceLang = dao.sourceLang {
            self.sourceLang = Lang(sourceLang)
        } else {
            return nil
        }

        if let targetLang = dao.targetLang {
            self.targetLang = Lang(targetLang)
        } else {
            return nil
        }

        isFavorite = dao.isFavorite
        createdAt = dao.createdAt
        updatedAt = dao.updatedAt
    }
}

extension Lang {

    init(_ dao: LangDAO) {
        id = .init(raw: dao._id)
        name = dao.name
        shortName = dao.shortName
    }
}

extension TranslationApiResponse {

    init(_ dao: TranslationApiResponseDAO) {
        url = dao.url
        data = dao.data
        httpResponseStatusCode = dao.httpResponseStatusCode
    }
}
