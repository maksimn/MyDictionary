//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture
import SwiftUI

let configFactory = ConfigFactory()
let config = configFactory.config()

let emptyLang = Lang(id: .init(raw: 0), name: "", shortName: "")
let lang = config.allLangs.first ?? emptyLang

let store = Store(
    initialState: LangPicker.State(lang: lang, langType: .source),
    reducer: LangPicker()._printChanges()
)

public struct ContentView: View {

    private let theme = Theme.data

    public init() { }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isHidden {
                    Button("Show LangPicker") {
                        viewStore.send(.show(lang: config.allLangs[2], langType: .source))
                    }
                } else {
                    LangPickerView(allLangs: config.allLangs, store: store)
                }
            }
            .background(theme.backgroundColor)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
