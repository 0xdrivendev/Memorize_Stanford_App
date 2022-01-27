//
//  MemoryGameModel.swift
//  Memorize_Stanford_App
//
//  Created by Elliott Diaz on 10/3/21.
//

import Foundation

struct MemoryGameModel<CardContent> where CardContent: Equatable{
  private(set) var cards: Array<Card> // private(set) allows others to view the variable but not modify
  
  private var indexOfTheOneAndOnlyFaceUpCard: Int? {
    get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
    set { cards.indices.forEach {cards[$0].isFaceUp  = ($0 == newValue) } } // cards.index equivalent to 0..<cards.count
  }
  
  init(numberOfCardPairs: Int, createCardContent: (Int) -> CardContent) {
    cards = []
    // add numberOfCardPairs
    
    for pairIndex in 0..<numberOfCardPairs {
      let content = createCardContent(pairIndex)
      cards.append(Card(content: content, id: pairIndex * 2))
      cards.append(Card(content: content, id: pairIndex * 2 + 1))
    }
  }
  
  mutating func choose(_ card: Card) {
    print(cards)
    print(card)
    if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
       !cards[chosenIndex].isFaceUp,
       !cards[chosenIndex].isMatched {
      
      if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
        if cards[chosenIndex].content == cards[potentialMatchIndex].content {
          cards[chosenIndex].isMatched = true
          cards[potentialMatchIndex].isMatched = true
        }
        cards[chosenIndex].isFaceUp = true
      } else {
        indexOfTheOneAndOnlyFaceUpCard = chosenIndex
      }
    }
  }
  
  mutating func shuffle() {
    cards.shuffle()
  }
  
  struct Card: Identifiable {
    var isFaceUp = false
    var isMatched = false
    let content: CardContent
    var id: Int
  }
}

extension Array {
  var oneAndOnly: Element? {
    if count == 1 {
      return first
    } else {
      return nil
    }
  }
}
