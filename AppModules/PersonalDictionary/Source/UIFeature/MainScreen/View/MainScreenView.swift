//
//  MainScreen.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainScreenView: View {

    let title: String
    let config: Config
    let store: StoreOf<MainScreen>
    let theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                MainWordListView(
                    store: store.scope(state: \.mainWordList, action: MainScreen.Action.mainWordList),
                    theme: theme
                )
                VStack {
                    Spacer()
                    LinkToNewWordView(
                        config: config,
                        store: store.scope(state: \.linkToNewWord, action: MainScreen.Action.linkToNewWord)
                    )
                }
            }
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .navigationTitle(title)
        }
    }
}
