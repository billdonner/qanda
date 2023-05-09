//
//  SupportViews.swift
//  qanda
//
//  Created by bill donner on 4/30/23.
//

import SwiftUI

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
  let dataSources : [GameDataSource] = [.localFull,.localBundle,.gameDataSource1,.gameDataSource2]
  @AppStorage("GameDataSource") var gameDataSource: GameDataSource = GameDataSource.localFull
  var body: some View {
    NavigationStack {
      Text("Score: \(stv.score)")
      Form {
        Section {
          Picker("Source", selection: $gameDataSource) {
            ForEach(dataSources, id: \.self) { ds in
              Text(GameDataSource.string(for:ds))
            }
          }
        }
      }
    }
  }
}
struct ShowScoresView_Previews: PreviewProvider {
  static var previews: some View {
    ShowScoresView(stv:PerTopicInfo(currentQuestionIndex: 1, showingAnswer: true, score: 99))
  }
}
