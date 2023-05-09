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
                VStack {
                    Spacer()
                    NavigationLink {
                        ZStack {
                            IfLetStore(
                                store.scope(state: \.newWord, action: MainWordList.Action.newWord)
                            ) {
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

struct MainWordListView_Previews: PreviewProvider {
    static var previews: some View {
        let config = ConfigFactory().config()

        MainWordListView(
            config: config,
            store: Store(
                initialState: .init(),
                reducer: MainWordList(
                    langRepository: LangRepositoryImpl(
                        userDefaults: UserDefaults.standard,
                        data: config.langData
                    )
                )
            ),
            theme: Theme.data
        )
    }
}
