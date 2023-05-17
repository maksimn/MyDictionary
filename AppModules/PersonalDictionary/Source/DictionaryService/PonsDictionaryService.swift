//
//  PonsDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
import CoreModule
import Foundation

final class PonsDictionaryService: DictionaryService {

    private let secret: String
    private let httpClient: HttpClient
    private let decoder: DictionaryEntryDecoder

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    private var cancellables: Set<AnyCancellable> = []

    init(secret: String, httpClient: HttpClient, decoder: DictionaryEntryDecoder) {
        self.secret = secret
        self.httpClient = httpClient
        self.decoder = decoder
    }

    func fetchDictionaryEntry(for word: Word) async throws -> Word {
        let sourceLang = word.sourceLang.shortName.lowercased()
        let targetLang = word.targetLang.shortName.lowercased()
        var query = URLComponents()

        query.queryItems = [
            URLQueryItem(name: "q", value: word.text),
            URLQueryItem(name: "l", value: sourceLang + targetLang)
        ]

        let http = Http(
            urlString: apiUrl + (query.string ?? ""),
            headers: ["X-Secret": secret]
        )

        let data = try await fetchData(http)
        var word = word

        word.dictionaryEntry = try await decoder.decode(data, word: word)

        return word
    }

    private func fetchData(_ http: Http) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
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
                        guard httpResponse.response.statusCode == 200 else {
                            return continuation.resume(
                                throwing: PonsDictionaryServiceError.dictionaryDataNotFetched(http)
                            )
                        }

                        continuation.resume(returning: httpResponse.data)
                    }
                ).store(in: &self.cancellables)
        }
    }
}

enum PonsDictionaryServiceError: Error {
    case dictionaryDataNotFetched(Http)
}
