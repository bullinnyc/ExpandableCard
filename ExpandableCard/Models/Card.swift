//
//  Card.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 07.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import Foundation

struct Card: Hashable {
    // MARK: - Public Properties
    
    let id = UUID()
    let title: String
    let color: String
}

// MARK: - Ext. Card for preview

extension Card {
    static func getCards() -> [Card] {
        [
            Card(title: "Card", color: "venus"),
            Card(title: "Card", color: "theia"),
            Card(title: "Card", color: "candy"),
            Card(title: "Card", color: "coffee"),
            Card(title: "Card", color: "newyork")
        ]
    }
}
