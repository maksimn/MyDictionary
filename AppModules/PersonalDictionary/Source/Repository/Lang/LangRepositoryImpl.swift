//
//  LangRepositoryImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

import Foundation

final class LangRepositoryImpl: LangRepository {

    private let userDefaults: UserDefaults
    private let data: LangData

    init(userDefaults: UserDefaults,
         data: LangData) {
        self.userDefaults = userDefaults
        self.data = data
    }

    func allLangs() -> [Lang] {
        data.allLangs
    }

    func sourceLang() -> Lang {
        findLang(with: data.sourceLangKey) ?? data.defaultSourceLang
    }

    func set(sourceLang: Lang) {
        userDefaults.set(sourceLang.id.raw, forKey: data.sourceLangKey)
    }

    func targetLang() -> Lang {
        findLang(with: data.targetLangKey) ?? data.defaultTargetLang
    }

    func set(targetLang: Lang) {
        userDefaults.set(targetLang.id.raw, forKey: data.targetLangKey)
    }

    private func findLang(with key: String) -> Lang? {
        let integer = userDefaults.integer(forKey: key)

        return data.allLangs.first(where: { $0.id == Lang.Id(raw: integer) })
    }
}
