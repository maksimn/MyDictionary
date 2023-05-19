//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

protocol WordDetailsFetcher {

    func wordDetails(_ id: Word.Id) throws -> WordDetailsVO
}

struct WordDetailsFetcherImpl: WordDetailsFetcher {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func wordDetails(_ id: Word.Id) throws -> WordDetailsVO {
        guard let realm = realmFactory.create() else {
            throw RealmFactoryError.realmNotCreated
        }
        guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: id.raw) else {
            throw WordDetailsFetcherError.wordDetailsNotFound
        }

        return WordDetailsVO(title: wordDAO.text, entry: Array(wordDAO.dictionaryEntry))
    }
}

enum WordDetailsFetcherError: Error {
    case wordDetailsNotFound
}
