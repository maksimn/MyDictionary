//
//  ToggleWordIsFavoriteEffect.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

protocol ToggleWordIsFavoriteEffect {

    func run(_ id: Word.Id) async throws -> Word
}

struct ToggleWordIsFavoriteEffectImpl: ToggleWordIsFavoriteEffect {

    let findWordDbWorker: FindWordDbWorker
    let updateWordDbWorker: UpdateWordDbWorker

    func run(_ id: Word.Id) async throws -> Word {
        guard let word = findWordDbWorker.find(id: id) else {
            throw _Error.wordNotFound(id)
        }
        var updatedWord = word

        updatedWord.isFavorite.toggle()

        try await updateWordDbWorker.update(word: updatedWord)

        return updatedWord
    }

    enum _Error: Error {
        case wordNotFound(Word.Id)
    }
}
