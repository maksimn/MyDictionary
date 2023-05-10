//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

protocol DeleteWordDbPerformer {

    func delete(word: Word) async throws
}

struct DeleteWordDbPerformerImpl: DeleteWordDbPerformer {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func delete(word: Word) async throws {
        try await make(operation: { (realm, word) in
            let wordDAO = realm.objects(WordDAO.self).where {
                $0._id == word.id.raw
            }

            realm.delete(wordDAO)
        }, with: word, realmFactory: realmFactory)
    }
}
