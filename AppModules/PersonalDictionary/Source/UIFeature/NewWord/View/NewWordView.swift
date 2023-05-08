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
                VStack {
                    VStack {
                        if viewStore.langPicker.isHidden {
                            HStack {
                                Button(action: {
                                    viewStore.send(.langPicker(.show(lang: viewStore.sourceLang, langType: .source)))
                                }) {
                                    Text(viewStore.sourceLang.name)
                                        .foregroundColor(theme.textColor)
                                }
                                .padding(.init(top: 12, leading: 0, bottom: 9, trailing: 8))
                                Text("⇋")
                                Button(action: {
                                    viewStore.send(.langPicker(.show(lang: viewStore.targetLang, langType: .target)))
                                }) {
                                    Text(viewStore.targetLang.name)
                                        .foregroundColor(theme.textColor)
                                }
                                .padding(.init(top: 12, leading: 8, bottom: 9, trailing: 0))
                            }
                            TextField(
                                "Enter a new word",
                                text: viewStore.binding(
                                    get: { $0.text },
                                    send: { .textChanged($0) }
                                )
                            )
                            .background(theme.cellColor)
                            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                            Button(action: {
                                viewStore.send(.newWord)
                            }) {
                                Text("OK")
                                    .padding(.init(top: 2, leading: 20, bottom: 2, trailing: 20))
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .bold))
                                    .background(.green)
                                    .cornerRadius(8)
                            }
                            .padding(.init(top: 10, leading: 0, bottom: 12, trailing: 0))
                        } else {
                            langPickerBuilder.build()
                        }
                    }
                    .background(Theme.data.backgroundColor)
                    .cornerRadius(16)
                }
                .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color(white: 0, opacity: 0.7))
            .edgesIgnoringSafeArea(.all)
            .textFieldStyle(.roundedBorder)
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
