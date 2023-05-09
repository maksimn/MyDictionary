//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct NewWordView<Builder>: View where Builder: SwiftViewBuilder {

    let store: StoreOf<NewWord>
    let langPickerBuilder: Builder
    let theme: Theme

    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>

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
                            .onSubmit {
                                dismiss(viewStore)
                            }
                            .background(theme.cellColor)
                            .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                            Button(action: {
                                dismiss(viewStore)
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
            .navigationBarBackButtonHidden(true)
        }
    }

    private func dismiss(_ viewStore: ViewStoreOf<NewWord>) {
        let word = Word(
            text: viewStore.text.trimmingCharacters(in: .whitespacesAndNewlines),
            sourceLang: viewStore.sourceLang,
            targetLang: viewStore.targetLang
        )
        let newWord = word.text.isEmpty ? nil : word

        viewStore.send(.sendNewWord(newWord))
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct NewWordView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}
    }
}
