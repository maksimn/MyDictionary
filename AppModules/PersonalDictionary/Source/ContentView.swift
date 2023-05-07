//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import SwiftUI

let configFactory = ConfigFactory()
let config = configFactory.config()
let builder = NewWordBuilder(config: config)

public struct ContentView: View {

    public init() { }

    public var body: some View {
        builder.build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
