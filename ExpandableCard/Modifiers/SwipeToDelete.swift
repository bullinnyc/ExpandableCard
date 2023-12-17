//
//  SwipeToDelete.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 08.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct SwipeToDelete: ViewModifier {
    // MARK: - Property Wrappers
    
    @State private var offsetX: CGFloat = .zero
    @State private var deletionOffsetX: CGFloat = .zero
    @State private var contentWidth: CGFloat = .zero
    @State private var willDelete = false
    @State private var didDelete = false
    
    // MARK: - Public Properties
    
    let deletionWidth: CGFloat
    let imageHeight: CGFloat
    let cornerRadius: CGFloat
    let isSwipeEnabled: Bool
    let action: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var deletionDistance: CGFloat {
        contentWidth * 0.8
    }
    
    private var halfDeletionDistance: CGFloat {
        deletionWidth * 0.5
    }
    
    private static let imageOpacity: Double = 0.8
    
    // MARK: - Body Method
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    let size = geometry.size
                    
                    background
                        .frame(width: -offsetX + cornerRadius)
                        .offset(x: size.width - cornerRadius)
                        .onAppear {
                            contentWidth = size.width
                        }
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    delete()
                                }
                        )
                }
            )
            .offset(x: offsetX, y: .zero)
            .highPriorityGesture(
                DragGesture()
                    .onChanged { gesture in
                        guard isSwipeEnabled else { return }
                        
                        let translation = gesture.translation
                        
                        guard abs(translation.width) >
                                abs(translation.height) else { return }
                        
                        if translation.width + deletionOffsetX <= .zero {
                            offsetX = translation.width + deletionOffsetX
                        }
                        
                        if offsetX < -deletionDistance && !willDelete {
                            impactFeedback()
                            willDelete.toggle()
                        } else if offsetX > -deletionDistance && willDelete {
                            impactFeedback()
                            willDelete.toggle()
                        }
                    }
                    .onEnded { _ in
                        guard isSwipeEnabled else { return }
                        
                        if offsetX < -deletionDistance {
                            delete()
                        } else if offsetX < -halfDeletionDistance {
                            showDeletion()
                        } else {
                            hideDeletion()
                        }
                    }
            )
            .animation(.interactiveSpring, value: offsetX)
            .onChange(of: isSwipeEnabled) { _, newValue in
                if !newValue, offsetX != .zero, deletionOffsetX != .zero {
                    withAnimation {
                        hideDeletion()
                    }
                }
            }
    }
    
    // MARK: - Private Methods
    
    private func delete() {
        offsetX = -contentWidth - contentWidth * 2
        didDelete = true
        action?()
    }
    
    private func showDeletion() {
        offsetX = -deletionWidth
        deletionOffsetX = -deletionWidth
    }
    
    private func hideDeletion() {
        offsetX = .zero
        deletionOffsetX = .zero
    }
    
    private func impactFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
}

// MARK: - Ext. Configure views

extension SwipeToDelete {
    private var background: some View {
        ZStack {
            Rectangle()
                .fill(Color("cherry"))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .padding(.leading, -cornerRadius)
            
            Image(systemName: "trash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color("night"))
                .frame(height: imageHeight)
                .padding(.leading, cornerRadius)
                .opacity(didDelete ? .zero : Self.imageOpacity)
        }
    }
}

// MARK: - Ext. View

extension View {
    func swipeToDelete(
        deletionWidth: CGFloat,
        imageHeight: CGFloat,
        cornerRadius: CGFloat = .zero,
        isSwipeEnabled: Bool,
        action: (() -> Void)? = nil
    ) -> some View {
        modifier(
            SwipeToDelete(
                deletionWidth: deletionWidth,
                imageHeight: imageHeight,
                cornerRadius: cornerRadius,
                isSwipeEnabled: isSwipeEnabled,
                action: action
            )
        )
    }
}
