//
//  WordVO.swift
//  
//
//  Created by Maksim Ivanov on 07.05.2023.
//

struct WordVO: Equatable, Identifiable {
    let _id: Word.Id
    let text: String
    let translation: String
    let sourceLang: String
    let targetLang: String

    init(_ word: Word) {
        _id = word.id
        text = word.text
        translation = word.dictionaryEntry.first ?? ""
        sourceLang = word.sourceLang.shortName
        targetLang = word.targetLang.shortName
    }

    var id: String {
        _id.raw
    }
}
