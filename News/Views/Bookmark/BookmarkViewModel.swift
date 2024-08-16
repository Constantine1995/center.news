//
//  BookmarkViewModel.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//

import Combine

class BookmarkViewModel: ObservableObject {
    
    let dataManager = DataManager.shared
    @Published var articles = [Article]()
    
    func isBookmarked(for article: Article) -> Bool {
        return articles.first { article.url == $0.url } != nil
    }
    
    func fetchBookmarks() {
        articles = dataManager.fetchArticles() ?? []
    }
    
    func saveArticle(for article: Article) {
        dataManager.saveArticle(article: article)
        articles.append(article)
    }
    
    func removeArticle(for article: Article) {
        articles = dataManager.removeArticle(for: article) ?? []
    }
}
