//
//  LinkToWordDetails.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct LinkToWordDetails: View {

    let wordId: Word.Id
    var isActive: Bool

    var body: some View {
        if isActive {
            NavigationLink {
                WordDetailsView(
                    store: Store(
                        initialState: .init(),
                        reducer: WordDetails(
                            id: wordId,
                            fetcher: WordDetailsFetcherImpl()
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
