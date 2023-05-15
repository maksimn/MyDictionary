//
//  PonsTranslationDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

final class PonsDictionaryEntryDecoder: DictionaryEntryDecoder {

    func decode(_ data: Data) async throws -> DictionaryEntry {
        return try await withCheckedThrowingContinuation { continuation in
            continuation.resume(returning: [])
        }
    }
}

/// Translation API docs: https://www.pons.com/p/files/uploads/pons/api/api-documentation.pdf
struct PonsResponseData: Codable {
    let hits: [PonsResponseDataHit]
}

struct PonsResponseDataHit: Codable {
    let roms: [PonsResponseDataHitsRom]
}

struct PonsResponseDataHitsRom: Codable {
    let arabs: [PonsResponseDataHitsRomsArab]
}

struct PonsResponseDataHitsRomsArab: Codable {
    let translations: [PonsResponseDataHitsRomsArabsTranslation]
}

struct PonsResponseDataHitsRomsArabsTranslation: Codable {
    let target: String
}
