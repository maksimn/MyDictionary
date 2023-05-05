//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

import CoreModule

/// Language.
struct Lang: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Lang, Int>

    /// The identifier of a language.
    let id: Id

    /// The name of a language.
    let name: String

    /// The short name for a language ("EN" for English, "RU" for Russian etc.)
    let shortName: String

    static func == (lhs: Lang, rhs: Lang) -> Bool {
        lhs.id == rhs.id
    }

    var description: String {
        "Lang(id: \(id.raw), name: \(name))"
    }
}
