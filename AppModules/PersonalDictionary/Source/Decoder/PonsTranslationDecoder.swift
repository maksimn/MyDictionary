//
//  PonsTranslationDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

final class PonsTranslationDecoder: TranslationDecoder {

    func decodeTranslation(for word: Word) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                guard let translationApiResponse = word.translationApiResponse else {
                    throw PonsTranslationDecoderError.noTranslationData(word)
                }

                guard translationApiResponse.url.starts(with: "https://api.pons.com/v1") else {
                    throw PonsTranslationDecoderError.ponsApiNotSupported
                }

                let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: translationApiResponse.data)
                let str = ponsArray.first?.hits.first?.roms.first?.arabs.first?.translations.first?.target ?? ""
                var translation = ""

                if let endIndex = str.firstIndex(of: "<") {
                    guard endIndex > str.startIndex && str.index(before: endIndex) > str.startIndex else {
                        throw PonsTranslationDecoderError.cannotCreateIndexRangeWhenParsing(word)
                    }

                    translation = String(str[..<str.index(before: endIndex)])
                } else {
                    translation = str
                }

                continuation.resume(returning: translation)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum PonsTranslationDecoderError: Error {
    case noTranslationData(Word)
    case ponsApiNotSupported
    case cannotCreateIndexRangeWhenParsing(Word)
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
