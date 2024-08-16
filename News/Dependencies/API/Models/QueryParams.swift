//
//  QueryParams.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation

struct QueryParams {
    var language: String = ""
    var sources: String = ""

    func getQueryParams() -> [String: Any] {
        return ["apiKey": Constants.apiKey, "language": language, "sources": sources]
    }
    
}
