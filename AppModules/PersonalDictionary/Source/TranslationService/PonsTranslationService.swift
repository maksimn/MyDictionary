//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
import CoreModule
import Foundation

final class PonsTranslationService: TranslationService {

    private let httpClient: HttpClient
    private let secret: String

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    private var cancellables: Set<AnyCancellable> = []

    init(secret: String, httpClient: HttpClient) {
        self.secret = secret
        self.httpClient = httpClient
    }

    func fetchTranslationData(for word: Word) async throws -> Word {
        let sourceLang = word.sourceLang.shortName.lowercased()
        let targetLang = word.targetLang.shortName.lowercased()
        var query = URLComponents()

        query.queryItems = [
            URLQueryItem(name: "q", value: word.text),
            URLQueryItem(name: "l", value: sourceLang + targetLang)
        ]

        let http = Http(
            urlString: apiUrl + (query.string ?? ""),
            method: "GET",
            headers: ["X-Secret": secret]
        )

        return try await withCheckedThrowingContinuation { continuation in
            httpClient.send(http)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { httpResponse in
                        guard 200...299 ~= httpResponse.response.statusCode else {
                            return continuation.resume(
                                throwing: PonsTranslationServiceError.translationNotFetched(word)
                            )
                        }

                        var word = word

                        word.translationApiResponse = TranslationApiResponse(
                            url: http.urlString,
                            data: httpResponse.data,
                            httpResponseStatusCode: httpResponse.response.statusCode
                        )

                        continuation.resume(returning: word)
                    }
                ).store(in: &self.cancellables)
        }
    }
}

enum PonsTranslationServiceError: Error {
    case translationNotFetched(Word)
}
