//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import SwiftUI

public struct ContentView: View {

    public init() { }

    public var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Oops, I did it again")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
