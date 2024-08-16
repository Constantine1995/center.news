//
//  ApiRoute.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation
import Alamofire

protocol CRApiRoute {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: Data? { get }
    var multipartData: MultipartFormData? { get }
    var parameters: [String: Any]? { get }
    var extraHeaders: [String: String]? { get }
    var queryParameters: [String: Any]? { get }
    var baseURL: String? { get }
}

// Default values
extension CRApiRoute {
    var queryParameters: [String: Any]? { nil }
    var body: Data? { nil }
    var parameters: [String: Any]? { nil }
    var multipartData: MultipartFormData? { nil }
    var extraHeaders: [String: String]? { nil }
    var baseURL: String? { nil }
}

extension Dictionary where Key == String {
    func toQueryParameters() -> [URLQueryItem] {
        return map { param -> URLQueryItem in
            URLQueryItem(name: param.key, value: "\(param.value)")
        }
    }
}

extension CRApiRoute {
    func getData(by dictionary: [String: String?]) -> Data? {
        try? JSONEncoder().encode(dictionary)
    }

    func getHeaders() -> [String: String] {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }
}
