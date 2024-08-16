//
//  BookmarkArticles+CoreDataProperties.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//
//

import Foundation
import CoreData


extension BookmarkArticles {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkArticles> {
        return NSFetchRequest<BookmarkArticles>(entityName: "BookmarkArticles")
    }

    @NSManaged var articles: [Article]?

}

extension BookmarkArticles : Identifiable {
    
    func updateData(article: Article) {
        var currentArticles = self.articles ?? []
        if !currentArticles.contains(where: { $0.url == article.url }) {
            currentArticles.append(article)
            self.articles = currentArticles
        }
    }
    
}
