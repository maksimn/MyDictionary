//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import CoreModule
import SwiftUI

struct MainWordListBuilder {

    let config: Config
    let store: StoreOf<MainWordList>

    func build() -> some View {
        MainWordListView(
            config: config,
            store: store,
            theme: Theme.data
        )
    }
}
