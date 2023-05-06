//
//  Lang.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 01.10.2021.
//

import CoreModule

/// A language.
struct Lang: Equatable, CustomStringConvertible {

    typealias Id = Tagged<Lang, Int>

    /// The identifier of the language.
    let id: Id

    /// The name of the language.
    let name: String

    /// The short name of the language ("EN" for English, "RU" for Russian etc.)
    let shortName: String

    static func == (lhs: Lang, rhs: Lang) -> Bool {
        lhs.id == rhs.id
    }

    var description: String {
        "Lang(id: \(id.raw), name: \(name))"
    }
}
