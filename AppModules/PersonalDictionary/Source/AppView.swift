//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import SwiftUI

private let newWordBuilder = NewWordBuilder(config: ConfigFactory().config())

public struct AppView: View {

    public init() { }

    public var body: some View {
        newWordBuilder.build()
    }
}
