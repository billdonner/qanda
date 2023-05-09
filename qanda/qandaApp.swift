//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI



struct MultiView: View {
  
  @StateObject  var gameState: GameState = GameState()
  
  @State var gameDatum: [GameData] = []
  
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.localFull
  func localBundle() {
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
  func localFileBundle(_ name:String )  {
    let u = Bundle.main.url(forResource: name , withExtension: "json")
    guard let u = u  else { print("cant find gamedata json file \(name)"); return  }
    do {
      let data = try Data(contentsOf: u)
      gameDatum = try JSONDecoder().decode([GameData].self,from:data)
    } catch {
          print("Cant load GameData from local full , \(error)")
        }
      }
  
  
  func fileBundle(_ url:String ) async  {
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
          print("Cant load GameData from \(url)")
        }
      //}
  }
  

  
  var body: some View {
    NavigationStack {
      Spacer()
      Text("Today's Topics:")
      Spacer()
      VStack {
        ForEachWithIndex (data:gameDatum) { index, qanda in
          NavigationLink(destination:
                          SingleTopicView(gs: gameState, index: index,  quizData: qanda)
          ) {
            HStack {
              Text(qanda.subject).font(.title).lineLimit(2)
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
           await  fileBundle("https://billdonner.com/fs/gd/gamedata01.json")
          
            case .gameDataSource2:
          await  fileBundle("https://billdonner.com/fs/gd/gamedata02.json")
            
            }
//            while gameDatum == [] {
//               sleep(1)
//            }
         
            var stvs : [PerTopicInfo] = []
            let xx = gameDatum.enumerated()
            for (_,_ ) in  xx {
              stvs.append(PerTopicInfo())
            }
          gameState.info = stvs
         }
        }
    }
  }
}

struct MultiView_Previews: PreviewProvider {
  static var previews: some View {
//    MultiView(gameDatum: [ GameData(subject:"Test",challenges: [
//      Challenge(id: "idstring", question: "question???", topic: "Test Topic", hint: "hint",
//                answers:[ "ans1","ans2"], answer: "ans2",
//                explanation: ["exp1","exp2"], article: "badurl", image: "badurl")])])
    MultiView()
    .navigationTitle("20,000 Questions")
  }
}

@main
struct qandaApp: App {
  
  var body: some Scene {
    WindowGroup {
      MultiView()
    }
  }
}
