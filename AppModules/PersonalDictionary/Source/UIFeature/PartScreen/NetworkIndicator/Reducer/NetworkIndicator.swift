//
//  NetworkIndicator.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture

struct NetworkIndicator: ReducerProtocol {

    let httpRequestCount: HttpRequestCountStream

    struct State: Equatable {
        var isVisible = false
    }

    enum Action {
        case initialize
        case show
        case hide
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .initialize:
            return .run { send in
                for await count in httpRequestCount.count {
                    await send(count > 0 ? .show : .hide)
                }
            }

        case .show:
            state.isVisible = true

        case .hide:
            state.isVisible = false
        }

        return .none
    }
}
