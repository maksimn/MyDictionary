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

    func delete(wordId: Word.Id) async throws -> Word.Id {
        try await make(operation: { (realm, word) in
            guard let wordDAO = realm.object(ofType: WordDAO.self, forPrimaryKey: wordId.raw) else {
                throw RealmWordError.wordNotFoundInRealm(wordId)
            }

            realm.delete(wordDAO)
        }, with: Word())

        return wordId
    }
}
