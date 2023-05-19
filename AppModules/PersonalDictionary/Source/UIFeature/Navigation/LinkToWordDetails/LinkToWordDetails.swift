//
//  LinkToWordDetails.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import CoreModule
import SwiftUI

struct LinkToWordDetails: View {

    let wordId: Word.Id
    var isActive: Bool
    let theme: Theme

    var body: some View {
        if isActive {
            NavigationLink {
                WordDetailsView(
                    store: Store(
                        initialState: .init(),
                        reducer: WordDetails(
                            id: wordId,
                            fetcher: WordDetailsFetcherImpl(
                                realmFactory: RealmFactoryImpl(logger: LoggerImpl(category: "WordDetails"))
                            )
                        )._printChanges()
                    ),
                    theme: Theme.data
                )
            } label: {
                EmptyView()
            }
            .opacity(0)
        } else {
            EmptyView()
        }
    }
}
