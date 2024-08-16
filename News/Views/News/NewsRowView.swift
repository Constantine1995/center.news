//
//  NewsRowView.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import SwiftUI

struct NewsRowView: View {
    
    @ObservedObject var bookmarkViewModel: BookmarkViewModel

    let article: Article
    var body: some View {
        VStack {
            
            HStack {
                AsyncImage(url: article.imageURL) { phase in
                    switch phase {
                    case .empty:
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        HStack {
                            Spacer()
                            Image(systemName: "photo")
                                .imageScale(.large)
                            Spacer()
                        }
                    @unknown default:
                        fatalError()
                    }
                }
                
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.headline)
                        .lineLimit(3)
                    
                    Text(article.descriptionText)
                        .font(.subheadline)
                        .lineLimit(2)
                    
                    HStack {
                        Text(article.captionText)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Spacer()
                        
                        HStack(spacing: 24) {
                            Button {
                                toggleBookmark(for: article)
                            } label: {
                                Image(systemName: bookmarkViewModel.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                            }.buttonStyle(.plain)
                            
                            Button {
                                presentShareSheet(url: article.articleURL)
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                            }.buttonStyle(.plain)
                        }
                    }
                }
 
            
            }
            .padding()
        }
    }
    
    func toggleBookmark(for article: Article) {
        if bookmarkViewModel.isBookmarked(for: article) {
            bookmarkViewModel.removeArticle(for: article)
        } else {
            bookmarkViewModel.saveArticle(for: article)
        }
    }
}
