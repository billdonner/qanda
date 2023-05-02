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
  
  @State  var gameDatum: [GameData] = []
  @State  var stv: [TopicStates] = []
  
  var body: some View {
    NavigationStack {
      Spacer()
      Text("Today's Topics:")
      Spacer()
      VStack {
        ForEachWithIndex (data:gameDatum) { index, qanda in
          NavigationLink(destination: SingleTopicView(stv: stv[index], quizData: qanda)) {
            HStack {
              Text(qanda.subject).font(.title)
            }
          }
        }
      }
      .navigationBarTitle("20,000 Questions")
      Spacer()
        .onAppear {
          if stv.count == 0 { // first time only
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
                print("Cant load json for topic \(topic) --  \(error))")
              }
            }
            var stvs : [TopicStates] = []
            for (n,_ ) in gameDatum.enumerated() {
              stvs.append(TopicStates(id:n))
            }
            self.stv = stvs
          }
        }
    }
  }
}

struct MultiView_Previews: PreviewProvider {
  static var previews: some View {
    MultiView(gameDatum: [ GameData(subject:"Test",challenges: [
      Challenge(id: "idstring", question: "question???", topic: "Test Topic", hint: "hint",
                answers:[ "ans1","ans2"], answer: "ans2",
                explanation: ["exp1","exp2"], article: "badurl", image: "badurl")])])
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
