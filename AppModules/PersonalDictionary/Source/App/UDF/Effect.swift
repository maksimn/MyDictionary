//
//  ContentView.swift
//  MyDictionary
//
//  Created by Maksim Ivanov on 05.05.2023.
//

import ComposableArchitecture

typealias AppEffectTask = EffectTask<App.Action>

protocol Effect {

    func run() -> AppEffectTask
}

protocol WordEffect {

    func run(_ word: Word) -> AppEffectTask
}
