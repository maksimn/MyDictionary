//
//  DeleteWordEffect.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture
import CoreModule

struct DeleteWordEffect: WordEffect {

    let dbWorker: DeleteWordDbWorker
    let logger: Logger

    func run(_ word: Word) -> AppEffectTask {
        .run { send in
            do {
                logger.debug("Delete word start: \(word) ")

                try await dbWorker.delete(word: word)

                logger.debug("Delete word success: \(word) ")
            } catch {
                logger.log("Delete word error, word: \(word)", level: .error)
                logger.errorWithContext(error)
            }
        }
    }
}
