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
    private let httpClient: HttpClientAdapter
    private let decoder: DictionaryEntryDecoder

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    private var cancellables: Set<AnyCancellable> = []

    init(secret: String, httpClient: HttpClientAdapter, decoder: DictionaryEntryDecoder) {
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

        let httpResult = try await httpClient.send(http)

        guard httpResult.response.statusCode == 200 else {
            throw PonsDictionaryServiceError.dictionaryDataNotFetched(http)
        }
        var word = word

        word.dictionaryEntry = try await decoder.decode(httpResult.data, word: word)

        return word
    }
}

enum PonsDictionaryServiceError: Error {
    case dictionaryDataNotFetched(Http)
}
