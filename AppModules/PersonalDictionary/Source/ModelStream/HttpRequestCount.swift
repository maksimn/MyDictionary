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

    static let instance = HttpRequestCount()

    private var onUpdate: ((Int) -> Void)?

    private var value = 0

    private init() { }

    private(set) lazy var count = AsyncStream<Int> { continuation in
        continuation.yield(value)

        onUpdate = { value in
            continuation.yield(value)
        }
    }

    func increment() {
        value += 1
        onUpdate?(value)
    }

    func decrement() {
        if value > 0 {
            value -= 1
            onUpdate?(value)
        }
    }
}
