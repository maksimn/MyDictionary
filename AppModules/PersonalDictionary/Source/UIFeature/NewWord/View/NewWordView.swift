//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct NewWordView<LangPickerBuilderType>: View where LangPickerBuilderType: SwiftViewBuilder {

    let store: StoreOf<NewWord>
    let langPickerBuilder: LangPickerBuilderType
    let theme: Theme

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.langPicker.isHidden {
                    HStack {
                        Button(action: {
                            viewStore.send(.langPicker(.show(lang: viewStore.sourceLang, langType: .source)))
                        }) {
                            Text(viewStore.sourceLang.name)
                        }
                        Text("⇋")
                        Button(action: {
                            viewStore.send(.langPicker(.show(lang: viewStore.targetLang, langType: .target)))
                        }) {
                            Text(viewStore.targetLang.name)
                        }
                    }
                    TextField(
                        "Enter a new word",
                        text: viewStore.binding(
                            get: { $0.text },
                            send: { .textChanged($0) }
                        )
                    )
                    Button(action: {
                        viewStore.send(.newWord)
                    }) {
                        Text("OK")
                    }
                } else {
                    langPickerBuilder.build()
                }
            }
            .background(Theme.data.backgroundColor)
        }
    }
}

struct NewWordView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ConfigFactory().config()
        let builder = NewWordBuilder(config: config)
        builder.build()
    }
}
