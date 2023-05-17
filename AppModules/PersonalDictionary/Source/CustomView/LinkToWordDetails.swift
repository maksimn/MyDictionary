//
//  LinkToWordDetails.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import SwiftUI

struct LinkToWordDetails: View {

    let word: Word
    let theme: Theme

    var body: some View {
        if word.dictionaryEntry.isEmpty {
            EmptyView()
        } else {
            NavigationLink {
                WordDetailsView(
                    word: word,
                    theme: Theme.data
                )
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
    }
}
