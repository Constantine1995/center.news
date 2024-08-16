//
//  NewsService.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Combine
import Alamofire

protocol NewsService {
    func getNews(params: QueryParams) -> AnyPublisher<NewsAPIResponse, Error>
}

class NewsServiceIml: NewsService {
    private let apiService = NewsApiService()

    func getNews(params: QueryParams) -> AnyPublisher<NewsAPIResponse, Error> {
        return apiService.getNews(params: params)
    }
}
