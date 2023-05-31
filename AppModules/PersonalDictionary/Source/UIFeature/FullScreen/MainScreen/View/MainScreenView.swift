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
    let allLangs: [Lang]
    let store: StoreOf<MainScreen>
    let theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                MainWordListView(
                    store: store.scope(state: \.mainWordList, action: MainScreen.Action.mainWordList)
                )
                VStack {
                    Spacer()
                    LinkToNewWordView(
                        allLangs: allLangs,
                        store: store.scope(state: \.linkToNewWord, action: MainScreen.Action.linkToNewWord)
                    )
                }
            }
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NetworkIndicatorView(
                        store: store.scope(state: \.networkIndicator, action: MainScreen.Action.networkIndicator)
                    )
                }
            }
            .navigationTitle(title)
        }
    }
}
