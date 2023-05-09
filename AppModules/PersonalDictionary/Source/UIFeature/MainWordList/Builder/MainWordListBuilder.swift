//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainWordListBuilder {

    private let config: Config

    private let store: StoreOf<MainWordList>

    init(config: Config) {
        self.config = config
        self.store = Store(
            initialState: .init(),
            reducer: MainWordList(
                langRepository: LangRepositoryImpl(userDefaults: UserDefaults.standard, data: config.langData)
            )._printChanges()
        )
    }

    func build() -> some View {
        MainWordListView(
            config: config,
            store: store,
            theme: Theme.data
        )
    }
}
