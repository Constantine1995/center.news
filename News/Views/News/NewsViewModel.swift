    //
    //  NewsViewModel.swift
    //  News
    //
    //  Created by Constantine Likhachov on 14.08.2024.
    //

import Combine
import Foundation

final class NewsViewModel: ObservableObject {
    @Published var news: NewsAPIResponse? = nil
    @Published var found: Bool = false
    @Published var resultError: Bool = false
    
    var newsService: NewsService = NewsServiceIml()
    var disposeBag = Set<AnyCancellable>()
    
    func getNews() {
        let params = QueryParams(language: "en", sources: "techcrunch")
        newsService.getNews(params: params)
            .sink {
                switch $0 {
                    case .finished:
                        break
                    case let .failure(error):
                        DispatchQueue.main.async {
                            self.found = false
                            self.resultError = true
                            print("Error: ", error)
                        }
                }
            } receiveValue: { [weak self] news in
                guard let self = self else { return }
                guard let articles = news.articles, !articles.isEmpty else {
                    DispatchQueue.main.async {
                        self.found = false
                        self.resultError = true
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.news = news
                    self.found = true
                    self.resultError = false
                }
            }.store(in: &disposeBag)
    }
}
