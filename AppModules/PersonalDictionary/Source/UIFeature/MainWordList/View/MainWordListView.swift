//
//  MainWordListView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct MainWordListView: View {

    let config: Config
    let store: StoreOf<MainWordList>
    let theme: Theme

    var body: some View {
        WithViewStore(self.store, observe: \.wordList) { viewStore in
            NavigationStack {
                ZStack {
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
                    VStack {
                        Spacer()
                        LinkToNewWord(config: config, store: store)
                    }
                }
                .background(theme.backgroundColor)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .navigationTitle("My dictionary")
            }
            .onAppear {
                viewStore.send(.loadSavedMainWordList)
            }
        }
    }
}
