//
//  BookmarkArticlesTransformer.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//

import Foundation

import CoreData
import Foundation

import os.log
import UIKit

@objc(BookmarkArticlesTransformer)
public final class BookmarkArticlesTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return NSData.self
    }

    override public class func allowsReverseTransformation() -> Bool {
        return true
    }

    override public func transformedValue(_ value: Any?) -> Any? {
        guard let article = value as? [Article] else {
            return nil
        }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: article, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }

    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            return nil
        }

        do {
            let article = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! [Article]
            return article
        } catch {
            return nil
        }
    }
}

extension BookmarkArticlesTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: BookmarkArticlesTransformer.self))

    public static func register() {
        let transformer = BookmarkArticlesTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
