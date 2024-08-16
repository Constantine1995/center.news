//
//  DataManager.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//

import Combine
import CoreData

enum EntityNames: String {
    case bookmarks = "BookmarkArticles"
    case news = "News"
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest(entityName: rawValue)
    }
}

class DataManager {
    static let shared = DataManager()
    
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: EntityNames.news.rawValue)
        BookmarkArticlesTransformer.register()

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load stores: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func getViewContext() -> NSManagedObjectContext {
        container.viewContext
    }

    func saveArticle(article: Article) {
        let context = getViewContext()

        context.perform {
            if let bookmarks = self.fetchBookmarks() {
                bookmarks.updateData(article: article)
                context.saveContext()
            } else {
                let entityName = EntityNames.bookmarks.rawValue
                let bookmarks = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! BookmarkArticles
                bookmarks.updateData(article: article)
                context.saveContext()
            }
        }
    }

    func fetchBookmarks() -> BookmarkArticles? {
        let context = getViewContext()
        let request = EntityNames.bookmarks.fetchRequest()
        return context.performAndWait {
            do {
                let bookmarks = try context.fetch(request) as! [BookmarkArticles]
                return bookmarks.first
            } catch {
                return nil
            }
        }
    }
    
    func fetchArticles() -> [Article]? {
        let context = getViewContext()
        let request = EntityNames.bookmarks.fetchRequest()
        return context.performAndWait {
            do {
                let articles = try context.fetch(request) as! [BookmarkArticles]
                return articles.first?.articles
            } catch {
                return nil
            }
        }
    }
    
    func removeArticle(for article: Article) -> [Article]? {
        let context = getViewContext()
        context.performAndWait {
            let request = EntityNames.bookmarks.fetchRequest()
            do {
                let bookmarkArticles = try context.fetch(request) as! [BookmarkArticles]
                guard let bookmarkArticle = bookmarkArticles.first else {
                    return
                }
                bookmarkArticle.articles?.removeAll { $0.url == article.url }
                context.saveContext()
            } catch {
                return
            }
        }
        return fetchArticles()
    }

}
