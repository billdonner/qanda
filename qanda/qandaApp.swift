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
  
  case localFull // keep first for easiest testing
  case gameDataSource1
  case gameDataSource2
  case gameDataSource3
  
 static  func string(for:Self) -> String {
    switch `for` {
  
    case .localFull:
      return "localFull"
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
  case showImage
  case showInfo
  case showScorePage
  case showHintBottomSheet
}
 struct SheetChoices:Identifiable {
  let id = UUID()
  let choice:Choices
  let arg: String?
}


// MARK :- Build Front Page

struct TodaysTopics: View {
  
  @StateObject  var gameState: GameState = GameState()
  @State var gameDatum: [GameData] = []
  
 @State var showSettings = false
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  
  //MARK : - data loaders
  
//  private func localBundle() {
//    for topic in ["food","vacation","oceans","us_presidents","the_himalayas","world_heritage_sites","new_york_city","rap_artists","rock_and_roll","elvis_presley"] {
//      do {
//        let prettyTopic = topic.replacingOccurrences(of: "_", with: " ")
//        let u = Bundle.main.url(forResource: topic , withExtension: "json")
//        guard let u = u  else { print("cant find json file \(topic)"); continue }
//        let data = try Data(contentsOf: u)
//        let challenges = try JSONDecoder().decode([Challenge].self, from: data)
//        gameDatum.append(GameData(subject:prettyTopic,challenges: challenges) )
//      }
//      catch {
//        print("Cant load local json for topic \(topic) --  \(error))")
//      }
//    }// for topic in
//  }
  
  private func localFileBundle(_ name:String )  {
    let u = Bundle.main.url(forResource: name , withExtension: "json")
    guard let u = u  else { print("cant find gamedata json file \(name)"); return  }
    do {
      let data = try Data(contentsOf: u)
      gameDatum = try JSONDecoder().decode([GameData].self,from:data)
    } catch {
      print("Cant load GameData from local full , \(error)")
    }
  }
  
  private  func fileBundle(_ url:String ) async  {
    func downloadFile(from url: URL ) async throws -> Data {
      let (data, _) = try await URLSession.shared.data(from: url)
      return data
    }
    guard let url = URL(string:url) else { print ("bad url \(url)"); return }
    // Task {
    do{
      let data = try await downloadFile(from:url)
      gameDatum = try JSONDecoder().decode([GameData].self,from:data)
    }
    catch {
      print("Cant load GameData from \(url), \(error)")
    }
  }
  
  
  var body: some View {
    NavigationStack {
      Spacer()
      Text("Today's Topics:")
      Spacer()
      VStack {
        ScrollView {
          ForEachWithIndex (data:gameDatum) { index, qanda in
            NavigationLink(destination:  ChallengeView(gs: gameState, index: index,  quizData: qanda)) {
              HStack {
                Text(qanda.subject).font(.title).lineLimit(2)
                Text("\(qanda.challenges.count)").font(.footnote)
              }
            }
          }
        }
        Spacer()
      }.navigationBarItems(trailing:     Button {
        showSettings = true
      } label: {
        Image(systemName: "gearshape")
      })
      .navigationBarTitle("20,000 Questions")
      Spacer()
        .task {
      if gameDatum.count == 0 { // first time only
          switch gameDataSource {
          case .localFull:
            localFileBundle("gamedata01")
          case .gameDataSource1:
            await  fileBundle(PRIMARY_REMOTE)
          case .gameDataSource2:
            await  fileBundle(SECONDARY_REMOTE)
          case .gameDataSource3:
            await  fileBundle(TERTIARY_REMOTE)
          }

        gameState.info = Array(repeating:PerTopicInfo(), count:gameDatum.count )
            } //
    }// task
    }.sheet(isPresented: $showSettings) {
    SettingsView (stv: gameState.info[0])//????
    }
  }
}

struct TodaysTopics_Previews: PreviewProvider {
  static var previews: some View {
    TodaysTopics()
  }
}

@main
struct qandaApp: App {
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  var body: some Scene {
    WindowGroup {
      TodaysTopics()
    }
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
struct ImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
    }
}


struct WebView: UIViewRepresentable {

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


struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
      Spacer()
        WebView(url: URL(string:"https://billdonner.com/images/paloaltojul2021.jpg")!)
      Spacer()
       
    }
}

struct SupportViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SupportViews_Previews: PreviewProvider {
    static var previews: some View {
        SupportViews()
    }
}
struct SettingsView: View {
  let stv: PerTopicInfo
  let dataSources : [GameDataSource] = [.gameDataSource1,.gameDataSource2,.gameDataSource3,.localFull]
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  var body: some View {
    NavigationStack {
      Form {
        
          Text("Score: \(stv.score)").font(.title)
        
        Section {
          
          Picker("Input Source", selection: $gameDataSource) {
            ForEach(dataSources, id: \.self) { ds in
              Text(GameDataSource.string(for:ds))
            }
          }
       
        Text("Be sure to Restart the app for change of input source to take effect").font(.footnote)
        }
        Section {
        
        }
      }.navigationTitle("Freeport Eyes Only")
    }
  }
}
struct ShowScoresView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView(stv:PerTopicInfo(currentQuestionIndex: 1, showingAnswer: true, score: 99))
  }
}
