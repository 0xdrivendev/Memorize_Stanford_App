//
//  Memorize_Stanford_App.swift
//  Memorize_Stanford_App
//
//  Created by Elliott Diaz on 9/26/21.
//

import SwiftUI

@main
struct MemorizeStanfordApp: App {
  
  private let game = MemoryGameViewModel()
  
  var body: some Scene {
    WindowGroup {
      MemoryGameView(game: game)
    }
  }
}
