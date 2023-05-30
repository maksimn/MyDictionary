//
//  PonsDictionaryService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import Foundation

struct PonsDictionaryService: DictionaryService {

    let secret: String
    let httpClient: HttpClientAdapter
    let decoder: DictionaryEntryDecoder

    private let apiUrl = "https://api.pons.com/v1/dictionary"

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
            throw _Error.dictionaryDataNotFetched(http)
        }
        var word = word

        word.dictionaryEntry = try await decoder.decode(httpResult.data, word: word)

        return word
    }

    enum _Error: Error {
        case dictionaryDataNotFetched(Http)
    }
}
