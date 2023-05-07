//
//  ConfigFactory.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 06.05.2023.
//

struct ConfigFactory {

    func config() -> Config {
        Config(
            langData: langData()
        )
    }

    private func langData() -> LangData {
        let lang1 = Lang(id: Lang.Id(raw: 1), name: "English", shortName: "EN")
        let lang2 = Lang(id: Lang.Id(raw: 2), name: "Russian", shortName: "RU")
        let lang4 = Lang(id: Lang.Id(raw: 4), name: "Italian", shortName: "IT")
        let lang5 = Lang(id: Lang.Id(raw: 5), name: "German", shortName: "DE")
        let langData = LangData(
            allLangs: [lang1, lang2, lang4, lang5],
            sourceLangKey: "io.github.maksimn.pd.sourceLang",
            targetLangKey: "io.github.maksimn.pd.targetLang",
            defaultSourceLang: lang1,
            defaultTargetLang: lang2
        )

        return langData
    }
}
