//
//  ExpandableCardApp.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 06.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

@main
struct ExpandableCardApp: App {
    var body: some Scene {
        WindowGroup {
            CardView(cards: Card.getCards())
        }
    }
}
