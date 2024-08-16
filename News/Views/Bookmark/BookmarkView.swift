//
//  BookmarkView.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import SwiftUI

struct BookmarkView: View {
    @EnvironmentObject var bookmarkViewModel: BookmarkViewModel

    @State private var selectedArticle: Article?
    @State var searchText: String = ""
    
    private var articles: [Article] {
        return bookmarkViewModel.articles
    }
    
    var filteredArticles: [Article] {
        guard !searchText.isEmpty else { return articles }
        return articles.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        VStack {
            if !articles.isEmpty {
                VStack(alignment: .leading) {
                    NavigationView {
                        List {
                            ForEach(filteredArticles, id: \.url) { article in
                                NewsRowView(bookmarkViewModel: bookmarkViewModel, article: article)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button(role: .destructive) {
                                            DispatchQueue.main.async {
                                                bookmarkViewModel.removeArticle(for: article)
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle.fill")
                                        }
                                    }
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
                PlaceholderView(title: "Bookmark is empty")
            }
        }
        .onAppear {
            bookmarkViewModel.fetchBookmarks()
        }
    }
}
