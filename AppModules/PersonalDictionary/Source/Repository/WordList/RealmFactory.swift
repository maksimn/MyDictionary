//
//  WordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import CoreModule
import RealmSwift

protocol RealmFactory {

    func create() -> Realm?
}

struct RealmFactoryImpl: RealmFactory {

    private let logger: CoreModule.Logger

    init(logger: CoreModule.Logger) {
        self.logger = logger
    }

    func create() -> Realm? {
        do {
            let realm = try Realm()

            return realm
        } catch {
            logger.log("\(error)", level: .error)

            return nil
        }
    }
}

enum RealmFactoryError: Error {
    case realmNotCreated
}
