//
//  HttpRequestCount.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 06.05.2023.
//

protocol HttpRequestCountMutator {

    func increment()

    func decrement()
}

protocol HttpRequestCountStream {

    var count: AsyncStream<Int> { get }
}

final class HttpRequestCount: HttpRequestCountMutator, HttpRequestCountStream {

    private init() { }

    static let instance = HttpRequestCount()

    private let store = IntValueStore()

    private(set) lazy var count = AsyncStream<Int> { continuation in
        continuation.yield(store.value)

        store.onUpdate = { value in
            continuation.yield(value)
        }
    }

    func increment() {
        store.onIncrement()
    }

    func decrement() {
        store.onDecrement()
    }
}

private final class IntValueStore {

    var onUpdate: ((Int) -> Void)?

    private(set) var value = 0

    func onIncrement() {
        value += 1
        onUpdate?(value)
    }

    func onDecrement() {
        if value > 0 {
            value -= 1
            onUpdate?(value)
        }
    }
}
