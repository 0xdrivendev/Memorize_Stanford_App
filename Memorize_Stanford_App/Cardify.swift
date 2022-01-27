//
//  Cardify.swift
//  Memorize_Stanford_App
//
//  Created by Elliott Diaz on 10/23/21.
//

import SwiftUI

struct Cardify: AnimatableModifier  {
  
  var rotation: Double // degrees
  var animatableData: Double {
    get { rotation }
    set { rotation = newValue }
  }
  
  init(isFaceUp: Bool) {
    rotation = isFaceUp ? 0 : 180
  }
  
  func body(content: Content) -> some View {
    ZStack {
      let cardShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
      if rotation < 90 {
        cardShape.fill().foregroundColor(.white)
        cardShape.stroke(lineWidth: DrawingConstants.lineWidth)
      } else {
        cardShape.fill().foregroundColor(.white)
        cardShape.stroke(lineWidth: DrawingConstants.lineWidth)
      }
      content.opacity(rotation < 90  ? 1 : 0)
    }
    .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
  }
  
  private struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
    static let lineWidth   : CGFloat = 3
  }
}

extension View {
  func cardify(isFaceUp: Bool) -> some View {
    return self.modifier(Cardify(isFaceUp: isFaceUp))
  }
}
