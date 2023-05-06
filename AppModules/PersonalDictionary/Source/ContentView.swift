//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import SwiftUI

public struct ContentView: View {

    private let theme = Theme.data

    public init() {
        let factory = ConfigFactory()
        let config = factory.config()

        print(config)
    }

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("My dictionary")
                .foregroundColor(theme.textColor)
        }
        .background(theme.backgroundColor)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
