//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI
import q20kshare

let PRIMARY_REMOTE = "https://billdonner.com/fs/gd/readyforios01.json"
let SECONDARY_REMOTE = "https://billdonner.com/fs/gd/readyforios02.json"
let TERTIARY_REMOTE = "https://billdonner.com/fs/gd/readyforios03.json"


enum GameDataSource : Int {
//
//  case localFull // keep first for easiest testing
  case gameDataSource1
  case gameDataSource2
  case gameDataSource3
  
  static  func string(for:Self) -> String {
    switch `for` {
    case .gameDataSource1:
      return PRIMARY_REMOTE
    case .gameDataSource2:
      return SECONDARY_REMOTE
    case .gameDataSource3:
      return TERTIARY_REMOTE
    }
  }
}

struct TopicState {
  var currentQuestionIndex: Int = 0
  var showingAnswer : Bool = false
  var score: Int = 0
}
//class foo:Observable {
//  internal init(a: Int, b: String) {
//    self.a = a
//    self.b = b
//  }
//  
//  var a: Int
//  var b: String
//}

class GameState : ObservableObject {
  let id:String = UUID().uuidString
  @Published var topicState:[TopicState] = []
  @Published var masterScore:Int = 0
}

enum Choices {
  case thumbsDown(Challenge)
  case thumbsUp(Challenge)
  case showScorePage
  case showChallengeInfoPage(Challenge)
  case showHintBottomSheet(String)
}
struct SheetChoices:Identifiable {
  internal init(choice: Choices,  challenge: Challenge? = nil, url: URL? = nil) {
    self.choice = choice
    self.challenge = challenge
    self.url = url
  }
  
  let id = UUID()
  let choice:Choices
  let challenge: Challenge?
  let url: URL?
}

//"CFBundleVersion"
extension UIApplication {
  static var appVersion: String? {
    let x =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    let y =  Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    guard let x=x, let y=y else {
      return nil }
    return x + "." + y
  }
  static var appName: String? {
    return  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
  }
}


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

struct InfoImageView: View {
  let imageName: String
  var body: some View {
    Image(imageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .clipped()
  }
}



@main
struct qandaApp: App {
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  var body: some Scene {
    let _ = print(( UIApplication.appName ?? "???") +  " " + ( UIApplication.appVersion ?? "???"))
    WindowGroup {
      FrontPageView()
    }
  }
}
