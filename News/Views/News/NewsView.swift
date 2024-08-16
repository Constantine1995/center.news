//
//  NewsView.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var bookmarkViewModel = BookmarkViewModel()

    @StateObject private var newsViewModel = NewsViewModel()
    @State private var selectedArticle: Article?
    @State var searchText: String = ""
    
    private var articles: [Article] {
        return newsViewModel.news?.articles ?? []
    }
    var filteredArticles: [Article] {
        guard !searchText.isEmpty else { return articles }
        return articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack {
            if newsViewModel.found {
                VStack(alignment: .leading) {
                    NavigationView {
                        List {
                            ForEach(filteredArticles, id: \.url) { article in
                                NewsRowView(bookmarkViewModel: bookmarkViewModel, article: article)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                            }
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .listStyle(.plain)
                        .searchable(text: $searchText, prompt: "Article Search")
                        .sheet(item: $selectedArticle) {
                            SafariView(url: $0.articleURL)
                                .edgesIgnoringSafeArea(.bottom)
                        }
                    }
                }
            } else {
                if newsViewModel.resultError {
                    PlaceholderView(title: "News is empty")
                } else {
                    ProgressView()
                        .onAppear {
                            newsViewModel.getNews()
                        }
                }
            }
        }
        .onAppear {
            bookmarkViewModel.fetchBookmarks()
        }
    }
}
