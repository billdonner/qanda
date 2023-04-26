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
struct ForEachWithIndex<
    Data: RandomAccessCollection,
    Content: View
>: View where Data.Element: Identifiable, Data.Element: Hashable {
    let data: Data
    @ViewBuilder let content: (Data.Index, Data.Element) -> Content
    var body: some View {
        ForEach(Array(zip(data.indices, data)), id: \.1) { index, element in
            content(index, element)
        }
    }
}

struct MultiView: View {
  internal init(gameData: [GameData]) {
    self.gameData = gameData
    var stvs : [STV] = []
    for (n,_ ) in gameData.enumerated() {
      stvs.append(STV(id:n))
    }
    self.stv = stvs
  }
  
  let gameData: [GameData]
  var stv: [STV] = []

  var body: some View {
    NavigationStack {
     Spacer()
      Text("Today's Topics:")
      Spacer()
      VStack {
        ForEachWithIndex (data:gameData) { index, qanda in
          NavigationLink(destination: SingleTopicView(stv: stv[index], quizData: qanda)) {
            HStack {
              Text(qanda.subject).font(.title)
            }
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
