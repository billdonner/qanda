//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI
//PROMPT consider the following structure
struct Challenge :Codable,Hashable,Identifiable,Equatable {
  let id : String
  let question: String
  let topic: String
  let hint:String // a hint to show if the user needs help
  let answers: [String]
  let correct: String // which answer is correct
  let explanation: String // reasoning behind the correctAnswer
  let article: String // URL of article about the correct Answer
  let image:String // URL of image of correct Answer
}
//let id = "wld date: april 29,2003 9:52AM"
// generate THREE challenges as an array of JSON about "Fun Fish Facts"
//let json_challenges = [

struct GameData : Codable, Hashable,Identifiable,Equatable {
  internal init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges //.shuffled()  //randomize
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
  case localBundle
  case gameDataSource1
  case gameDataSource2
  
 static  func string(for:Self) -> String {
    switch `for` {
    case .localBundle:
      return "local"
    case .localFull:
      return "localFull"
    case .gameDataSource1:
     return "source1"
    case .gameDataSource2:
      return "source2"
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
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.localFull
  
  //MARK : - data loaders
  
  private func localBundle() {
    for topic in ["food","vacation","oceans","us_presidents","the_himalayas","world_heritage_sites","new_york_city","rap_artists","rock_and_roll","elvis_presley"] {
      do {
        let prettyTopic = topic.replacingOccurrences(of: "_", with: " ")
        let u = Bundle.main.url(forResource: topic , withExtension: "json")
        guard let u = u  else { print("cant find json file \(topic)"); continue }
        let data = try Data(contentsOf: u)
        let challenges = try JSONDecoder().decode([Challenge].self, from: data)
        gameDatum.append(GameData(subject:prettyTopic,challenges: challenges) )
      }
      catch {
        print("Cant load local json for topic \(topic) --  \(error))")
      }
    }// for topic in
  }
  
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
        ForEachWithIndex (data:gameDatum) { index, qanda in
          NavigationLink(destination:  SingleTopicView(gs: gameState, index: index,  quizData: qanda)) {
            HStack {
              Text(qanda.subject).font(.title).lineLimit(2)
              Text("\(qanda.challenges.count)").font(.footnote)
            }
          }
        }
      }
      .navigationBarTitle("20,000 Questions")
      Spacer()
        .task {
      if gameDatum.count == 0 { // first time only
          switch gameDataSource {
          case .localBundle:
            localBundle()
          case .localFull:
            localFileBundle("gamedata01")
          case .gameDataSource1:
            await  fileBundle("https://billdonner.com/fs/gd/readyforios.json")
          case .gameDataSource2:
            await  fileBundle("https://billdonner.com/fs/gd/gamedata02.json")
          }

        gameState.info = Array(repeating:PerTopicInfo(), count:gameDatum.count )
            } //
    }// task
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



struct SingleTopicView: View {
  @StateObject var gs: GameState
  let index:Int
  let quizData: GameData
  @State  private var sheetchoice: SheetChoices? = nil
  var body: some View {
    NavigationStack {
      
      let stv = gs.info[index]
      let finally = (stv.currentQuestionIndex == quizData.challenges.count-1) && stv.showingAnswer
      let qd = quizData.challenges[stv.currentQuestionIndex]
      VStack {
        Text("Question \(stv.currentQuestionIndex+1)")
          .font(.subheadline)
        Text(qd.question)
          .font(.title).padding()
        ForEach(0 ..< qd.answers.count, id:\.self) { number in
          Button(action: {
            if quizData.challenges[stv.currentQuestionIndex].answers[number] == quizData.challenges[stv.currentQuestionIndex].correct {
              gs.info[index].score += 1
              gs.masterScore += 1
            }
            gs.info[index].showingAnswer = true
          }) {
            Text("\(qd.answers[number])")
          }
          .padding()
        }
        if stv.showingAnswer {
          Text("Answer: \(qd.correct)")
            .font(.title).padding()
          Text("Explanation:" + qd.explanation).font(.headline).padding()
        }
        //        Spacer()
      }// vstack
      .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(stv.score)") {
        sheetchoice = SheetChoices(choice:.showScorePage,arg:"")
      }
        .navigationBarTitle(Text(quizData.subject + "\(finally ? " Finally Done " : "")"))
                          
                          
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar){
            Button(finally ? "Start Over":"Previous") {
              if finally {
                gs.info[index].currentQuestionIndex = 0
                gs.info[index].showingAnswer = false
                gs.info[index].score = 0
              } else {
                if stv.currentQuestionIndex > 0 {
                  gs.info[index].currentQuestionIndex -= 1
                  gs.info[index].showingAnswer = false
                }
              }
            }
            .disabled(stv.currentQuestionIndex == 0)
            
            Button {
              sheetchoice = SheetChoices(choice:.showImage,arg:qd.image)
            } label: {
              Image(systemName: "photo")
            }
            .disabled(qd.image=="" || !stv.showingAnswer)
            Spacer()
            Button {
              sheetchoice = SheetChoices(choice:.showInfo,arg:qd.article)
            } label: {
              Image(systemName: "info")
            }
            .disabled(qd.article=="" || !stv.showingAnswer)
    
            Button("Next") {
              if stv.currentQuestionIndex + 1 < quizData.challenges.count {
                gs.info[index].currentQuestionIndex += 1
                gs.info[index].showingAnswer = false
              } //else {
                // game is over
              //}
            }
            .disabled(stv.currentQuestionIndex == quizData.challenges.count-1 )
          }
        }// toolbar
      )
      
      .sheet(item:$sheetchoice){sc in
        switch sc.choice {
        case .showImage :
          if let s = sc.arg , let url = URL(string: s) {
            let _ = print ("will show Image" + (sc.arg ?? "") )
            WebView(url:url)
          }
        case .showInfo :
          if let s = sc.arg, let url = URL(string: s) {
           let _ =  print("will show article " + (sc.arg ?? "") )
            WebView(url:url)
          }
        case .showScorePage :
          let _ =  print("will show scores " + (sc.arg ?? "") )
          ShowScoresView(stv:stv)
        }
      }//sheet
    }
  }
}


struct SingleTopicView_Previews: PreviewProvider {
  static var previews: some View {
    SingleTopicView(gs:  GameState(), index:0 ,
                    quizData: GameData(subject:"Test",challenges: [
                      Challenge(id: "idstring", question: "question???", topic: "Test Topic", hint: "hint", answers:[ "ans1","ans2"], correct: "ans2", explanation:  "exp1" , article: "badurl", image: "badurl")]))
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
struct ShowScoresView: View {
  let stv: PerTopicInfo
  let dataSources : [GameDataSource] = [.gameDataSource1,.gameDataSource2,.localFull,.localBundle]
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.localFull
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
        }
      }.navigationTitle("Freeport Eyes Only")
    }
  }
}
struct ShowScoresView_Previews: PreviewProvider {
  static var previews: some View {
    ShowScoresView(stv:PerTopicInfo(currentQuestionIndex: 1, showingAnswer: true, score: 99))
  }
}

 



