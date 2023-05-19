//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct WordDetailsView: View {

    let store: StoreOf<WordDetails>
    let theme: Theme

    var body: some View {
        WithViewStore(self.store, observe: \.details) { viewStore in
            List(viewStore.entry, id: \.self) { entryItem in
                Text(entryItem)
            }
            .background(theme.backgroundColor)
            .navigationBarTitle(viewStore.title)
            .onAppear {
                viewStore.send(.loadWordDetails)
            }
        }
    }
}
