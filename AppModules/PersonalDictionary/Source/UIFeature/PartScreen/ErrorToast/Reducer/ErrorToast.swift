//
//  ErrorToast.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 02.06.2023.
//

import ComposableArchitecture

struct ErrorToast: ReducerProtocol {

    let errorMessageStream: ErrorMessageStream
    let clock: ContinuousClock
    let durationSeconds: Int

    struct State: Equatable {
        var isVisible = false
        var text = ""
    }

    enum Action {
        case initialize
        case show(ErrorMessage)
        case hide
        case hideAfterDelay
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .initialize:
            return .run { send in
                for await errorMessage in errorMessageStream.error {
                    await send(.show(errorMessage))
                    await send(.hideAfterDelay)
                }
            }

        case .show(.error(let text)):
            guard !state.isVisible else { break }

            state.isVisible = true
            state.text = text

        case .hide:
            state.isVisible = false
            state.text = ""

        case .hideAfterDelay:
            return .run { send in
                try await clock.sleep(for: .seconds(durationSeconds))
                await send(.hide)
            }
        }

        return .none
    }
}
