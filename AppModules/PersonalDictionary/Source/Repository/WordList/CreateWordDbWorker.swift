//
//  CreateWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

protocol CreateWordDbWorker {

    func create(word: Word) async throws
}

struct CreateWordDbWorkerImpl: CreateWordDbWorker {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func create(word: Word) async throws {
        try await make(operation: { (realm, word) in
            realm.add(WordDAO(word))
        }, with: word, realmFactory: realmFactory)
    }
}
