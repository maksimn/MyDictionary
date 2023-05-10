//
//  LangPickerBuilder.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import ComposableArchitecture
import CoreModule
import SwiftUI

struct LangPickerBuilder: SwiftViewBuilder {

    private let store: StoreOf<LangPicker>
    private let allLangs: [Lang]

    init(store: StoreOf<LangPicker>, allLangs: [Lang]) {
        self.store = store
        self.allLangs = allLangs
    }

    func build() -> some View {
        LangPickerView(
            allLangs: allLangs,
            store: store
        )
    }
}
