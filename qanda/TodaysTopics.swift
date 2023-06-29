//
//  TodaysTopics.swift
//  qanda
//
//  Created by bill donner on 6/9/23.
//

import SwiftUI

// MARK :- Build Front Page

struct TodaysTopics: View {
  
  @StateObject  var gameState: GameState = GameState()
  @State var gameDatum: [GameData] = []
  
  @State var showSettings = false
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  

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
//            case .localFull:
//              localFileBundle("gamedata01")
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
