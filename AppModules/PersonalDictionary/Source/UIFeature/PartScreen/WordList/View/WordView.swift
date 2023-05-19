//
//  WordView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import SwiftUI

struct WordView: View {

    let word: WordVO
    let theme: Theme

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(word.text)
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.textColor)
                Text(word.translation)
                    .lineLimit(1)
                    .font(theme.normalFont)
                    .foregroundColor(theme.textColor)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(word.sourceLang)
                    .setLangShortNameStyle(theme)
                Text(word.targetLang)
                    .setLangShortNameStyle(theme)
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
