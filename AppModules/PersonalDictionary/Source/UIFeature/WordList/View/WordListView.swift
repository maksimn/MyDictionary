//
//  WordListView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct WordListView: View {

    let store: StoreOf<WordList>
    let theme: Theme

    var body: some View {
        WithViewStore(self.store, observe: \.wordList) { viewStore in
            List {
                ForEach(viewStore.state) { item in
                    ZStack {
                        WordView(word: item.word, theme: theme)
                        LinkToWordDetails(word: item.word, theme: theme)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = viewStore.state[index]

                        viewStore.send(.delete(item.word))
                    }
                }
            }
        }
    }
}
