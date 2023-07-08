//
//  TodaysTopics.swift
//  qanda
//
//  Created by bill donner on 6/9/23.
//

import SwiftUI
import q20kshare

// MARK :- Build Front Page

struct FrontPageView: View {
  
  @StateObject  var gameState: GameState = GameState()
  @State
  private var gameDatum: [GameData] = []
  
  @State var showSettings = false
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.gameDataSource1
  
  @State var isDownloading = false
  
  private  func fileBundle2(_ url:String ) async  {
    func downloadFile(from url: URL ) async throws -> Data {
      let data = try Data(contentsOf:url)
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
  private  func loadFrom(_ url:String ) async  {
    func downloadFile(from url: URL ) async throws -> Data {
      let (data, _) = try await URLSession.shared.data(from: url)
      return data
    }
    guard let url = URL(string:url) else { print ("bad url \(url)"); return }
    // Task {
    do{
      let start_time = Date()
      let data = try await downloadFile(from:url)
      gameDatum = try JSONDecoder().decode([GameData].self,from:data)
      let elapsed = Date().timeIntervalSince(start_time)
      let challengeCount = gameDatum.reduce(0,{$0 + $1.challenges.count})
      print("Loaded \(gameDatum.count) topics, \(challengeCount) challenges in \(elapsed) secs")
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
      ZStack {
        VStack {
          ProgressView("Loading ...")
        }.opacity(isDownloading ? 1.0 : 0.0)
        VStack {
          ScrollView {
            ForEachWithIndex (data:gameDatum) { index, quizData in
              NavigationLink(destination:  SoloTopicView(gs: gameState, topicIndex: index,  gameData: quizData)) {
                HStack {
                  Text(quizData.subject).font(.title).lineLimit(2)
                  Text("\(quizData.challenges.count)").font(.footnote)
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
              isDownloading = true
              switch gameDataSource {
              case .gameDataSource1:
                await loadFrom(PRIMARY_REMOTE)
              case .gameDataSource2:
                await loadFrom(SECONDARY_REMOTE)
              case .gameDataSource3:
                await  loadFrom(TERTIARY_REMOTE)
              }
              gameState.topicState = Array(repeating:TopicState(), count:gameDatum.count )
              isDownloading = false
            } // first
          }// task
      }
      .sheet(isPresented: $showSettings) {
        SettingsView (stv: gameState.topicState[0])//????
      }
    }
  }
}
