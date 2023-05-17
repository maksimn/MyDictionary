//
//  NewWordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import SwiftUI

struct WordDetailsView: View {

    let word: Word
    let theme: Theme

    var body: some View {
        List(word.dictionaryEntry, id: \.self) { translation in
            Text(translation)
        }
        .background(theme.backgroundColor)
        .navigationBarTitle(word.text)
    }
}
