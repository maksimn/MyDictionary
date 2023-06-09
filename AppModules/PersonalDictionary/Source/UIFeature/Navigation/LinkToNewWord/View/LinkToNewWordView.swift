//
//  LinkToNewWord.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct LinkToNewWordView: View {

    let allLangs: [Lang]
    let store: StoreOf<LinkToNewWord>

    var body: some View {
        NavigationLink {
            ZStack {
                IfLetStore(store.scope(state: \.newWord, action: LinkToNewWord.Action.newWord)) {
                    NewWordView(
                        store: $0,
                        langPickerView: LangPickerView(
                            allLangs: allLangs,
                            store: $0.scope(state: \.langPicker, action: NewWord.Action.langPicker)
                        ),
                        theme: Theme.data
                    )
                }
            }
            .onAppear {
                ViewStore(store.stateless).send(.navigateToNewWord)
            }
        } label: {
            Image("icon-plus", bundle: Bundle.module)
                .resizable()
                .frame(width: 44, height: 44)
                .padding(.bottom, 24)
        }
    }
}
