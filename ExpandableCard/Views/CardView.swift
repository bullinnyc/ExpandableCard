//
//  CardView.swift
//  ExpandableCard
//
//  Created by Dmitry Kononchuk on 06.12.2023.
//  Copyright © 2023 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct CardView: View {
    // MARK: - Property Wrappers
    
    @State private var cards: [Card]
    @State private var isExpanded = false
    
    // MARK: - Private Properties
    
    private let cardPackMax: Int
    private let isVolumetricPack: Bool
    private let isHideColoredCardPack: Bool
    private let onTap: ((Int) -> Void)?
    
    private static let cardHeight: CGFloat = 100
    private static let cardSpacing: CGFloat = 1.1
    private static let cardScale: CGFloat = 0.06
    private static let cardWithSpacing = Self.cardHeight * Self.cardSpacing
    private static let cardPackTopPaddingPercent: CGFloat = 9
    private static let cardPackTopPadding: CGFloat = 50
    private static let cardPackHorizontalPadding: CGFloat = 18
    private static let cardTextFontSize: CGFloat = 28
    private static let cardTextOpacity: Double = 0.8
    private static let lessButtonOpacity: Double = 0.8
    private static let lessButtonSize: CGSize = CGSize(width: 125, height: 38)
    private static let lessButtonFontSize: CGFloat = 17
    private static let controlImageSize: CGSize = CGSize(width: 16, height: 9)
    private static let standartPadding: CGFloat = 16
    private static let cornerRadius: CGFloat = 16
    private static let deletionWidth: CGFloat = 80
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if isExpanded {
                lessButton
            }
            
            ForEach(
                Array(cards.enumerated().reversed()),
                id: \.element
            ) { index, card in
                self.card(for: card)
                    .if(isHideColoredCardPack) { view in
                        view
                            .overlay(hideColoredCardPack(for: index))
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .scaleEffect(getCardScale(for: index), anchor: .bottom)
                    .padding(.top, getCardTopPadding(for: CGFloat(index)))
                    .opacity(
                        isExpanded
                            ? 1
                            : index < cardPackMax ? 1 : .zero
                    )
                    .onTapGesture {
                        if isExpanded || cards.count == 1 {
                            onTap?(index)
                        }
                        
                        if !isExpanded, index == .zero, cards.count > 1 {
                            isExpanded.toggle()
                        }
                    }
            }
            .padding(.top, isExpanded ? Self.cardPackTopPadding : .zero)
        }
        .padding(
            .horizontal,
            isVolumetricPack ? Self.cardPackHorizontalPadding : .zero
        )
        .fixedSize(horizontal: false, vertical: true)
        .hidden(cards.isEmpty, remove: true)
        .animation(.bouncy, value: isExpanded)
    }
    
    // MARK: - Initializers
    
    init(
        cards: [Card],
        cardPackMax: Int = 3,
        isVolumetricPack: Bool = true,
        isHideColoredCardPack: Bool = true,
        onTap: ((Int) -> Void)? = nil
    ) {
        self.cardPackMax = cardPackMax
        self.isVolumetricPack = isVolumetricPack
        self.isHideColoredCardPack = isHideColoredCardPack
        self.onTap = onTap
        
        _cards = State(wrappedValue: cards)
    }
    
    // MARK: - Private Methods
    
    private func getCardScale(for index: Int) -> CGFloat {
        if isExpanded {
            return 1
        }
        
        let cardScale = isVolumetricPack ? Self.cardSpacing : 1
        return cardScale - CGFloat(index) * Self.cardScale
    }
    
    private func getCardTopPadding(for index: CGFloat) -> CGFloat {
        if isExpanded {
            let expandedCardTopPadding = index * Self.cardWithSpacing
            return expandedCardTopPadding
        }
        
        let cardPackTopPadding = index < CGFloat(cardPackMax)
            ? index * Self.cardPackTopPaddingPercent
            : .zero
        
        return cardPackTopPadding
    }
}

// MARK: - Ext. Configure views

extension CardView {
    private var lessButton: some View {
        Button {
            isExpanded = false
        } label: {
            ZStack {
                Color("nightAndDay")
                    .clipShape(
                        RoundedRectangle(cornerRadius: Self.cornerRadius)
                    )
                
                HStack {
                    Image(systemName: "control")
                        .resizable()
                        .frame(
                            width: Self.controlImageSize.width,
                            height: Self.controlImageSize.height
                        )
                    
                    Text("Show less")
                        .font(.custom(seravek, size: Self.lessButtonFontSize))
                }
                .foregroundStyle(Color("dayAndNight"))
            }
            .opacity(Self.lessButtonOpacity)
        }
        .buttonStyle(.plain)
        .frame(
            width: Self.lessButtonSize.width,
            height: Self.lessButtonSize.height
        )
        .transition(.move(edge: .bottom))
    }
    
    private func card(for card: Card) -> some View {
        ZStack {
            Color(card.color)
            
            GeometryReader { geometry in
                let size = geometry.size
                
                Text(card.title)
                    .font(.custom(seravek, size: Self.cardTextFontSize))
                    .foregroundStyle(Color("night"))
                    .padding([.leading, .top], Self.standartPadding)
                    .padding(.trailing, size.width * 0.42)
                    .frame(height: Self.cardHeight, alignment: .top)
                    .opacity(Self.cardTextOpacity)
            }
        }
        .frame(height: Self.cardHeight)
        .swipeToDelete(
            deletionWidth: Self.deletionWidth,
            imageHeight: Self.cardHeight * 0.25,
            cornerRadius: Self.cornerRadius,
            isSwipeEnabled: isExpanded || cards.count == 1
        ) {
            withAnimation {
                cards.removeAll(where: { $0.id == card.id })
                
                if isExpanded {
                    isExpanded = !cards.isEmpty
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Self.cornerRadius))
    }
    
    @ViewBuilder
    private func hideColoredCardPack(for index: Int) -> some View {
        if !isExpanded, index < cardPackMax, index != .zero {
            ZStack {
                Color("day")
                
                Color("night")
                    .opacity(Double(index) * 0.18)
            }
            .clipShape(RoundedRectangle(cornerRadius: Self.cornerRadius))
        }
    }
}

// MARK: - Preview

#Preview {
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
