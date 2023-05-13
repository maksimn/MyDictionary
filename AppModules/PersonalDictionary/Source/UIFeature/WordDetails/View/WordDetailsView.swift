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
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            List(viewStore.word.dictionaryEntry, id: \.self) { translation in
                Text(translation)
            }
            .background(theme.backgroundColor)
            .navigationBarTitle(viewStore.word.text)
        }
    }
}
