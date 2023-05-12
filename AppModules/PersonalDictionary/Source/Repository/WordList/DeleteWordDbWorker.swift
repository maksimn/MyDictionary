//
//  DeleteWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

protocol DeleteWordDbWorker {

    func delete(word: Word) async throws
}

struct DeleteWordDbWorkerImpl: DeleteWordDbWorker {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func delete(word: Word) async throws {
        try await make(operation: { (realm, word) in
            guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: word.id.raw) else { return }

            realm.delete(wordDAO)
        }, with: word, realmFactory: realmFactory)
    }
}
