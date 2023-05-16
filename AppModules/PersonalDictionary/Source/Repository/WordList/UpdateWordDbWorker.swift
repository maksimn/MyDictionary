//
//  UpdateWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 11.05.2023.
//

protocol UpdateWordDbWorker {

    func update(word: Word) async throws
}

struct UpdateWordDbWorkerImpl: UpdateWordDbWorker {

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
