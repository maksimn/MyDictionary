//
//  UpdateWordDbPerformer.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2023.
//

import RealmSwift

protocol UpdateWordDbPerformer {

    func update(word: Word) async throws
}

struct UpdateWordDbPerformerImpl: UpdateWordDbPerformer {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func update(word: Word) async throws {
        try await make(operation: { (realm, word) in
            guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: word.id.raw) else { return }

            wordDAO.update(from: word)
        }, with: word, realmFactory: realmFactory)
    }
}
