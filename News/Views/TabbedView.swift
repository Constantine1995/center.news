//
//  TabbedView.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import SwiftUI

struct TabbedView: View {
    @StateObject var navigation: NavigationController

    var body: some View {
        ZStack {
            TabView(selection: $navigation.selectedTab) {
                TabViewElement(navigation: navigation, screen: NewsView(),

                               selectedTab: $navigation.selectedTab,
                               tabType: .news)
                .environmentObject(navigation)
                
                TabViewElement(navigation: navigation, screen: BookmarkView(),
                               selectedTab: $navigation.selectedTab,
                               tabType: .bookmark)
                .environmentObject(navigation)
            }
            .tint(.black)
        }
        .onAppear {
            setupAppearance()
        }
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = getAttributes(selected: false)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = getAttributes(selected: true)
        let offset = UIOffset(horizontal: 0, vertical: 5)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.configureWithTransparentBackground()
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func getAttributes(selected: Bool) -> [NSAttributedString.Key: NSObject] {
        return [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(selected ? 1 : 0.4)]
    }
}

struct TabItem {
    let unselectedIcon: Image
    let activeIcon: Image
    let title: String?
}

enum TabType: Int {
    case news
    case bookmark
    
    var item: TabItem {
        switch self {
            case .news:
                return .init(unselectedIcon: Image(systemName: "newspaper"),
                             activeIcon: Image(systemName: "newspaper"),
                             title: "News")
            case .bookmark:
                return .init(unselectedIcon: Image(systemName: "bookmark"),
                             activeIcon: Image(systemName: "bookmark"),
                             title: "Bookmark")
        }
    }
}

struct TabViewElement<Content>: View where Content: View {
    @StateObject var navigation: NavigationController
    let screen: Content
    @Binding var selectedTab: Int
    let tabType: TabType
    
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Color.white
                    .frame(height: 100)
            }
            .ignoresSafeArea(edges: .bottom)
            screen
                .padding(.bottom, 17)
        }
        .tabItem {
            if let title = tabType.item.title {
                Text(title)
                
            }
            if selectedTab == tabType.rawValue {
                tabType.item.activeIcon
                    .renderingMode(.template)
                    .foregroundColor(.black)
            } else {
                tabType.item.unselectedIcon
                
            }
        }
        .tag(tabType.rawValue)
    }
}

#Preview {
    TabbedView(navigation: NavigationController())
}
