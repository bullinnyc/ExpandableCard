//
//  Hidden.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 08.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct Hidden: ViewModifier {
    // MARK: - Public Properties
    
    let hidden: Bool
    let remove: Bool
    
    // MARK: - Body Method
    
    func body(content: Content) -> some View {
        if hidden {
            !remove ? content.hidden() : nil
        } else {
            content
        }
    }
}

// MARK: - Ext. View

extension View {
    /// Method overloading – hidden(). Hides or removes the view.
    ///
    /// Hide view:
    ///
    ///     Button(action: signIn) {
    ///         Text("Sign In")
    ///     }
    ///     .hidden(true)
    ///
    /// Delete view:
    ///
    ///     Button(action: signIn) {
    ///         Text("Sign In")
    ///     }
    ///     .hidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `true` to hide the view. Set to `false` to show the view.
    ///   - remove: Set to `true` to remove the view. Set to `false` not to remove the view.
    ///
    /// - Returns: A hidden, deleted or the self view.
    func hidden(_ hidden: Bool, remove: Bool = false) -> some View {
        modifier(Hidden(hidden: hidden, remove: remove))
    }
}
