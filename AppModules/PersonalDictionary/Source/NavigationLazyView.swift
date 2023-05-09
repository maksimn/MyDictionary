//
//  NavigationLazyView.swift
//  
//
//  Created by Maksim Ivanov on 09.05.2023.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {

    private let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
