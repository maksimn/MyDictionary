//
//  LangRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol LangRepository {

    func allLangs() -> [Lang]

    func sourceLang() -> Lang

    func set(sourceLang: Lang)

    func targetLang() -> Lang

    func set(targetLang: Lang)
}
