//
//  AppView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture
import SwiftUI

private let config = ConfigFactory().config()
private let mainScreen = MainScreen(config: config)
private let store = Store(
    initialState: .init(),
    reducer: mainScreen._printChanges()
)

public struct AppView: View {

    public init() { }

    public var body: some View {
        MainScreenView(
            title: "My dictionary",
            config: config,
            store: store,
            theme: Theme.data
        )
    }
}
