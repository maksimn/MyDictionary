//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

protocol WordListFetcher {

    func wordList() throws -> [Word]
}

struct WordListFetcherImpl: WordListFetcher {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func wordList() throws -> [Word] {
        guard let realm = realmFactory.create() else {
            throw RealmFactoryError.realmNotCreated
        }

        return realm.objects(WordDAO.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .compactMap { Word($0) }
    }
}
