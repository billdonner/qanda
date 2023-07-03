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

struct GameData : Codable, Hashable,Identifiable,Equatable {
  internal init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges.shuffled()  //randomize
    self.id = UUID().uuidString
    self.generated = Date()
  }
  
  let id : String
  let subject: String
  let challenges: [Challenge]
  let generated: Date
}
enum GameDataSource : Int {
//
//  case localFull // keep first for easiest testing
  case gameDataSource1
  case gameDataSource2
  case gameDataSource3
  
  static  func string(for:Self) -> String {
    switch `for` {
      
//    case .localFull:
//      return "localFull"
    case .gameDataSource1:
      return PRIMARY_REMOTE
    case .gameDataSource2:
      return SECONDARY_REMOTE
    case .gameDataSource3:
      return TERTIARY_REMOTE
    }
  }
}

struct PerTopicInfo {
  var currentQuestionIndex: Int = 0
  var showingAnswer : Bool = false
  var score: Int = 0
}


class GameState : ObservableObject {
  let id:String = UUID().uuidString
  @Published var info:[PerTopicInfo] = []
  @Published var masterScore:Int = 0
  // @Published var masterTopicIndex:Int = 0
}

enum Choices {
  case thumbsDown(URL)
  case thumbsUp(URL)
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


import WebKit
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
struct WebView: View {
  let url:URL
  @Environment(\.presentationMode) var presentationMode
  var body: some View {
    ZStack {
      WebViewx(url:url)
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        VStack {
          HStack{ Spacer() ;  Image(systemName: "xmark.circle").padding()}
          Spacer()
        }
      }
    }
  }
}

struct WebViewx: UIViewRepresentable {
  
  let url:URL
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.load(URLRequest(url: url))
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.load(URLRequest(url: url))
  }
}
struct WebView_Previews: PreviewProvider {
  static var previews: some View {
    WebView(url: URL(string:"https://www.apple.com")!)
      .edgesIgnoringSafeArea(.all)
  }
}



struct SettingsView: View {
  let stv: PerTopicInfo
  let dataSources : [GameDataSource] = [.gameDataSource1,.gameDataSource2,.gameDataSource3]
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  var body: some View {
    NavigationStack {
      VStack{
        let zz = UIApplication.appVersion ?? "??"
        Form {
          
          Text("Score: \(stv.score)").font(.title)
          
          Section {
            
            Picker("Source", selection: $gameDataSource) {
              ForEach(dataSources, id: \.self) { ds in
                Text(GameDataSource.string(for:ds))
              }
            }
           
          }
          Section {
            Text("Be sure to Restart the app for change of input source to take effect").font(.footnote)
            
          }
        }.navigationTitle("Freeport " + zz)
      }
    }
  }
}
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(stv:PerTopicInfo(currentQuestionIndex: 1, showingAnswer: true, score: 99))
  }
}
