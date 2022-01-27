//
//  MemoryGameViewModel.swift
//  Memorize_Stanford_App
//
//  Created by Elliott Diaz on 10/3/21.
//

import SwiftUI

// Observable
//  Making an object behave like an 'ObservableObject' enable it to publish that the model has made changes
class MemoryGameViewModel: ObservableObject {
  
  typealias Card = MemoryGameModel<String>.Card
  
  static let contents = ["c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "c10",
                  "c11", "c12", "c13", "c14", "c15", "c16", "c17", "c18", "c19", "c20"]
  
  static func createMemoryGameModel() -> MemoryGameModel<String> {
    MemoryGameModel<String>(numberOfCardPairs: 3) { pairIndex in
      MemoryGameViewModel.contents[pairIndex]
    }
  }
  
  // Published - means that anytime that variable is changed, it will publish to the world that something changed to redraw
  @Published private var model = createMemoryGameModel()
  
  var cards: Array<Card> {
    model.cards
  }
  
  // MARK: - Intent(s)
  
  func choose(_ card: Card) {
    //objectWillChange.send() // objectWillChange does not have to be defined - simply access it
    model.choose(card)
  }
  
  func shuffle() {
    model.shuffle()
  }
}

