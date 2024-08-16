//
//  NewsApiRouter.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Alamofire

enum NewsApiRouter: CRApiRoute {
    case getNews(params: QueryParams)

    var method: HTTPMethod {
        switch self {
            case .getNews:
                return .get
        }
    }

    var path: String {
        switch self {
        case .getNews:
            return "/v2/top-headlines?"
        }
    }

    var queryParameters: [String: Any]? {
        switch self {
            case let .getNews(params):
                return params.getQueryParams()
        }
    }

    var extraHeaders: [String: String]? {
        switch self {
            case .getNews:
            return getHeaders()
        }
    }
}
