//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import RealmSwift

final class WordListRepositoryImpl: WordListRepository {

    private let logger: CoreModule.Logger

    init(logger: CoreModule.Logger) {
        self.logger = logger
    }

    func wordList() throws -> [Word] {
        guard let realm = realm() else {
            throw WLRError.realmNotCreated
        }

        return realm.objects(WordDAO.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .compactMap { Word($0) }
    }

    func create(word: Word) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let realm = realm() else {
                return continuation.resume(throwing: WLRError.realmNotCreated)
            }

            do {
                try realm.write {
                    let wordDAO = WordDAO(word)

                    realm.add(wordDAO)
                    continuation.resume()
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    func delete(word: Word) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            guard let realm = realm() else {
                return continuation.resume(throwing: WLRError.realmNotCreated)
            }

            do {
                try realm.write {
                    let wordDAO = realm.objects(WordDAO.self).where {
                        $0._id == word.id.raw
                    }

                    realm.delete(wordDAO)
                    continuation.resume()
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func realm() -> Realm? {
        var realm: Realm?
        do {
            realm = try Realm()
        } catch {
            logger.log("\(error)", level: .error)
        }

        return realm
    }

    enum WLRError: Error {
        case realmNotCreated
    }
}
