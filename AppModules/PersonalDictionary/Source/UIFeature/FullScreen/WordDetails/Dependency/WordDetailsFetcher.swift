//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import RealmSwift

protocol WordDetailsFetcher {

    func wordDetails(_ id: Word.Id) throws -> WordDetailsVO
}

struct WordDetailsFetcherImpl: WordDetailsFetcher {

    func wordDetails(_ id: Word.Id) throws -> WordDetailsVO {
        let realm = try Realm()
        let wordDAO = try realm.findWordBy(id: id)

        return WordDetailsVO(title: wordDAO.text, entry: Array(wordDAO.dictionaryEntry))
    }
}
