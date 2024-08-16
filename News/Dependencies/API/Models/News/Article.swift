//
//  Article.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation

class Article: NSObject, Codable, NSSecureCoding, Identifiable {
   
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    let source: Source
    let title: String
    let url: String
    let publishedAt: String?
    let author: String?
    let descriptions: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case descriptions = "description"
        case urlToImage
    }
        
    public func encode(with coder: NSCoder) {
        coder.encode(source, forKey: CodingKeys.source.rawValue)
        coder.encode(title, forKey: CodingKeys.title.rawValue)
        coder.encode(url, forKey: CodingKeys.url.rawValue)
        coder.encode(publishedAt, forKey: CodingKeys.publishedAt.rawValue)
        coder.encode(author, forKey: CodingKeys.author.rawValue)
        coder.encode(descriptions, forKey: CodingKeys.descriptions.rawValue)
        coder.encode(urlToImage, forKey: CodingKeys.urlToImage.rawValue)
    }

    public required init(coder decoder: NSCoder) {
        let defaultSource = Source(id: "", name: "")
        source = decoder.decodeObject(forKey: CodingKeys.source.rawValue) as? Source ?? defaultSource
        title = decoder.decodeObject(forKey: CodingKeys.title.rawValue) as? String ?? ""
        url = decoder.decodeObject(forKey: CodingKeys.url.rawValue) as? String ?? ""
        publishedAt = decoder.decodeObject(forKey: CodingKeys.publishedAt.rawValue) as? String
        author = decoder.decodeObject(forKey: CodingKeys.author.rawValue) as? String
        descriptions = decoder.decodeObject(forKey: CodingKeys.descriptions.rawValue) as? String
        urlToImage = decoder.decodeObject(forKey: CodingKeys.urlToImage.rawValue) as? String
        super.init()
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        descriptions ?? ""
    }
    
    var captionText: String {
        let date = publishedAt ?? ""
        return "\(source.name) • \(date.formattedDate())"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
}

class Source: NSObject, Codable, NSSecureCoding {
    let id: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    static var supportsSecureCoding: Bool {
        return true
    }
        
    init(id: String, name: String) {
          self.id = id
          self.name = name
      }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: CodingKeys.id.rawValue)
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
    
    public required init(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: CodingKeys.id.rawValue) as? String ?? ""
        name = decoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String ?? ""
        super.init()
    }
    
}
