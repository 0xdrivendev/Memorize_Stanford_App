//
//  ContentView.swift
//  Memorize_Stanford_App
//
//  Created by Elliott Diaz on 9/26/21.
//


// bookmark: lecture 8 54:00 min mark

import SwiftUI

struct MemoryGameView: View {
  
  // ObservedObject - when something has been published, rebuilds he view
  @ObservedObject var game: MemoryGameViewModel
  @State private var dealt = Set<Int>() // A Set is a collection of unique values
  @Namespace private var dealingNamespace
  
  var body: some View {
    VStack {
      gameBody
      deckBody
      shuffle
    }
    .padding()
  }
  
  private func deal(_ card: MemoryGameViewModel.Card) {
    dealt.insert(card.id)
  }
  
  private func isUndealt(_ card: MemoryGameViewModel.Card) -> Bool {
    return !dealt.contains(card.id)
  }
  
  var gameBody: some View {
    
    AspectVGrid(items:game.cards, aspectRatio: 2/3) { card in
      
      if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
        Color.clear
        
      } else {
        CardView(card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .padding(4)
          .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale)) // identity means to not perform an animation
          .onTapGesture {
            withAnimation {
              game.choose(card)
            }
          }
      }
    }
    .foregroundColor(CardConstants.color)
  }
  
  var deckBody: some View {
    ZStack {
      ForEach(game.cards.filter(isUndealt)) { card in
        CardView(card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
        
      }
    }
    .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    .foregroundColor(CardConstants.color)
    .onTapGesture {
      withAnimation(.easeInOut(duration: CardConstants.animationDuration)) {
        for card in game.cards {
          deal(card)
        }
      }
    }
  }
  
  var shuffle: some View {
    Button("Shuffle") {
      withAnimation {
        game.shuffle()
      }
    }
  }
  
  private struct CardConstants {
    static let color            : Color   = Color.blue
    static let undealtHeight    : CGFloat = 90
    static let undealtWidth     : CGFloat = 60
    static let animationDuration: Double  = 1.0
  }
}

struct CardView: View {
  
  private let card: MemoryGameViewModel.Card
  
  init(_ card: MemoryGameViewModel.Card) {
    self.card = card
  }
  
  var body: some View {
    
    GeometryReader { geometry in
      
      ZStack {
        Pie(startAngle: Angle(degrees: 0-90),
            endAngle: Angle(degrees: 110-90))
          .padding(DrawingConstants.PiePadding).opacity(DrawingConstants.PieOpacity)
        
        Text(card.content)
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false))
          .font(Font.system(size: DrawingConstants.fontSize))
          .scaleEffect(scale(thatFits: geometry.size))
        
      }
      .cardify(isFaceUp: card.isFaceUp)
    }
  }
  
  private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
  }
  
  private struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
    static let lineWidth   : CGFloat = 3
    static let fontScale   : CGFloat = 0.7
    static let PiePadding  : CGFloat = 0.5
    static let PieOpacity  : Double  = 0.5
    static let fontSize    : CGFloat = 32
  }
  
  private func font(in size: CGSize) -> Font {
    Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = MemoryGameViewModel()
    
    game.choose(game.cards.first!)
    
    return MemoryGameView(game: game)
  }
}
