//
//  PlaceholderView.swift
//  News
//
//  Created by Constantine Likhachov on 15.08.2024.
//

import SwiftUI

struct PlaceholderView: View {
    
    var title: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
            Text(title)
                .bold()
        }
    }
}
