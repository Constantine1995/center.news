//
//  NewsAPIResponse.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation

struct NewsAPIResponse: Codable {
    
    let totalResults: Int?
    let articles: [Article]?
    
    let status: String
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status, 
             totalResults,
             articles,
             code,
             message
    }

    // MARK: Decodable

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        articles = try values.decodeIfPresent([Article].self, forKey: .articles)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(totalResults, forKey: .totalResults)
        try container.encode(articles, forKey: .articles)
        try container.encode(code, forKey: .code)
        try container.encode(message, forKey: .message)
    }
    
}
