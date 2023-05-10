//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import RealmSwift

func make(operation: (Realm, Word) -> Void, with word: Word, realmFactory: RealmFactory) async throws {
    return try await withCheckedThrowingContinuation { continuation in
        guard let realm = realmFactory.create() else {
            return continuation.resume(throwing: RealmFactoryError.realmNotCreated)
        }

        do {
            try realm.write {
                operation(realm, word)
                continuation.resume()
            }
        } catch {
            continuation.resume(throwing: error)
        }
    }
}
