//
//  ContentView.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 11.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Body
    
    var body: some View {
        VStack {
            CardView(cards: Card.getCards()) { index in
                print("Card tapped: \(index)")
            }
            
            Text("Some content")
                .font(.custom(seravek, size: 16))
                .padding(.top)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
