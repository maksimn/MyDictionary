//
//  MainWordListView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainWordListView: View {

    let store: StoreOf<MainWordList>

    init(store: StoreOf<MainWordList>) {
        self.store = store
        ViewStore(store.stateless).send(.loadSavedMainWordList)
    }

    var body: some View {
        WithViewStore(self.store, observe: \.wordList) { viewStore in
            WordListView(
                store: store.scope(state: \.wordList, action: MainWordList.Action.wordList),
                theme: Theme.data
            )
        }
    }
}
