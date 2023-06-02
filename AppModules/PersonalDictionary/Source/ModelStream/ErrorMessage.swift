//
//  ErrorMessage.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 02.06.2023.
//

enum ErrorMessage {
    case error(String)
}

protocol ErrorMessageSender {

    func send(_ error: ErrorMessage)
}

protocol ErrorMessageStream {

    var error: AsyncStream<ErrorMessage> { get }
}

final class ErrorMessageStreamImpl: ErrorMessageSender, ErrorMessageStream {

    static let instance = ErrorMessageStreamImpl()

    private var onNext: ((ErrorMessage) -> Void)?

    private init() { }

    func send(_ error: ErrorMessage) {
        onNext?(error)
    }

    private(set) lazy var error = AsyncStream<ErrorMessage> { continuation in
        onNext = { error in
            continuation.yield(error)
        }
    }
}
