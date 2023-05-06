//
//  ConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.05.2023.
//

struct ConfigFactory {

    func config() -> Config {
        Config(
            allLangs: allLangs()
        )
    }

    private func allLangs() -> [Lang] {
        let lang1 = Lang(id: Lang.Id(raw: 1), name: "English", shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: "Russian", shortName: "RU")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: "Italian", shortName: "IT")
        let lang5 = Lang(id: Lang.Id(raw: 5), name: "German", shortName: "DE")

        return [lang1, lang2, lang4, lang5]
    }
}
