//
//  SettingsView.swift
//  qanda
//
//  Created by bill donner on 7/6/23.
//

import SwiftUI 
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
            Text("Be sure to Restart the app for change of input source to take effect")
              .font(.footnote)
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
