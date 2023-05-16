//
//  LoadSavedMainWordListEffect.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture
import CoreModule

struct LoadSavedMainWordListEffect: Effect {

    let wordListFetcher: WordListFetcher
    let logger: Logger

    func run() -> AppEffectTask {
        .run { send in
            do {
                let wordList = try wordListFetcher.wordList()

                await send(.mainWordList(.savedWordListLoaded(wordList)))
            } catch {
                logger.errorWithContext(error)
            }
        }
    }
}
