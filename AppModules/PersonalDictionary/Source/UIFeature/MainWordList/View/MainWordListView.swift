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
        WithViewStore(self.store) { viewStore in
            NavigationStack {
                ZStack {
                    List {
                        ForEach(viewStore.wordList) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.word.text)
                                        .lineLimit(1)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(theme.textColor)
                                    Text("[translation]")
                                        .lineLimit(1)
                                        .font(theme.normalFont)
                                        .foregroundColor(theme.textColor)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text(item.word.sourceLang.shortName)
                                        .setLangShortNameStyle(theme)
                                    Text(item.word.targetLang.shortName)
                                        .setLangShortNameStyle(theme)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let item = viewStore.wordList[index]

                                viewStore.send(.delete(item.word))
                            }
                        }
                    }
                    VStack {
                        Spacer()
                        NavigationLink {
                            ZStack {
                                IfLetStore(store.scope(state: \.newWord, action: MainWordList.Action.newWord)) {
                                    NewWordBuilder(config: config, store: $0).build()
                                }
                            }
                            .onAppear {
                                viewStore.send(.showNewWordView)
                            }
                        } label: {
                            Image("icon-plus", bundle: Bundle.module)
                                .resizable()
                                .frame(width: 44, height: 44)
                                .padding(.bottom, 24)
                        }
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
        }
    }
}

extension Text {

    func setLangShortNameStyle(_ theme: Theme) -> some View {
        lineLimit(1)
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(theme.secondaryTextColor)
    }
}
