//
//  Builder.swift
//  
//
//  Created by Maksim Ivanov on 08.05.2023.
//

import SwiftUI

protocol SwiftViewBuilder {
    associatedtype ViewType: View

    func build() -> ViewType
}
