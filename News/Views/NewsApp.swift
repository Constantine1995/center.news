//
//  NewsApp.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import SwiftUI

@main
struct NewsApp: App {
    @StateObject private var bookmarkViewModel = BookmarkViewModel()

    var body: some Scene {
        let navigation = NavigationController()
        
        WindowGroup {
            TabbedView(navigation: navigation)
                .environmentObject(bookmarkViewModel)

        }
    }
}
