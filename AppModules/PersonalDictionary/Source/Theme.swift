//
//  Theme.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 06.05.2023.
//

import SwiftUI

struct Theme {

    let backgroundColor: Color

    let goldColor: Color

    let cellColor: Color

    let textColor: Color

    let secondaryTextColor: Color

    let inversedTextColor: Color

    let normalFont: Font

    private init(backgroundColor: Color,
                 goldColor: Color,
                 cellColor: Color,
                 textColor: Color,
                 secondaryTextColor: Color,
                 inversedTextColor: Color,
                 normalFont: Font) {
        self.backgroundColor = backgroundColor
        self.goldColor = goldColor
        self.cellColor = cellColor
        self.textColor = textColor
        self.secondaryTextColor = secondaryTextColor
        self.inversedTextColor = inversedTextColor
        self.normalFont = normalFont
    }

    static let data = Theme(
        backgroundColor: Color("Background", bundle: Bundle.module),
        goldColor: Color(red: 1.00, green: 0.84, blue: 0.00),
        cellColor: Color("Cell", bundle: Bundle.module),
        textColor: Color("Text", bundle: Bundle.module),
        secondaryTextColor: Color("SecondaryText", bundle: Bundle.module),
        inversedTextColor: Color("InversedText", bundle: Bundle.module),
        normalFont: Font.system(size: 17)
    )
}
