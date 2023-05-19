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

    func update(word: Word) async throws {
        try await make(operation: { (realm, word) in
            guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: word.id.raw) else {
                throw RealmWordError.wordNotFoundInRealm(word.id)
            }

            wordDAO.update(from: word)
        }, with: word)
    }
}
