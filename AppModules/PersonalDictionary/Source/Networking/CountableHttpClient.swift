//
//  CountableHttpClient.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 06.05.2023.
//

import CoreModule

struct CountableHttpClient: HttpClientAdapter {

    let httpClient: HttpClientAdapter
    let mutator: HttpRequestCountMutator

    init(httpClient: HttpClientAdapter = HttpClientAdapterImpl(),
         mutator: HttpRequestCountMutator = HttpRequestCount.instance) {
        self.httpClient = httpClient
        self.mutator = mutator
    }

    func send(_ http: Http) async throws -> HttpResponseResult {
        mutator.increment()

        do {
            let httpResult = try await httpClient.send(http)

            mutator.decrement()

            return httpResult
        } catch {
            mutator.decrement()
            throw error
        }
    }
}
