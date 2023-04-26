//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI

// Print JSON to Console
func printJSon(_ g:GameData) {
  let encoder = JSONEncoder()
  encoder.outputFormatting = .prettyPrinted
  if let jsonData = try? encoder.encode(g) {
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print(jsonString)
  }
}
struct MultiView: View {
  let gameData: [GameData]

  var body: some View {
    NavigationStack {
     Spacer()
      Text("Today's Topics:")
      Spacer()
      VStack {
        ForEach (gameData) { qanda in
          NavigationLink(destination: SingleTopicView(stv: STV(), quizData: qanda)) {
            Text(qanda.subject).font(.title)
          }
        }
      }
      .navigationBarTitle("20,000 Questions")
      Spacer()
    }
  }
    
  }

struct MultiView_Previews: PreviewProvider {
  static var previews: some View {
    MultiView(gameData: chatGPT_GENERATED_DATA)
      .navigationTitle("20,000 Questions")
  }
}

@main
struct qandaApp: App {
    var body: some Scene {
        WindowGroup {
          MultiView(gameData: chatGPT_GENERATED_DATA)
        }
    }
}
