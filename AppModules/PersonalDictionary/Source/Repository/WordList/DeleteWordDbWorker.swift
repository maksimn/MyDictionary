//
//  DeleteWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol DeleteWordDbWorker {

    func delete(wordId: Word.Id) async throws -> Word.Id
}

struct DeleteWordDbWorkerImpl: DeleteWordDbWorker {

    private let realmFactory: RealmFactory

    init(realmFactory: RealmFactory) {
        self.realmFactory = realmFactory
    }

    func delete(wordId: Word.Id) async throws -> Word.Id {
        try await make(operation: { (realm, word) in
            guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: wordId.raw) else { return }

            realm.delete(wordDAO)
        }, with: Word(), realmFactory: realmFactory)

        return wordId
    }
}
