//
//  NewsApiService.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Combine

class NewsApiService: CRApiService {

    func getNews(params: QueryParams) -> AnyPublisher<NewsAPIResponse, Error> {
        return perform(apiRoute: NewsApiRouter.getNews(params: params))
    }

}
