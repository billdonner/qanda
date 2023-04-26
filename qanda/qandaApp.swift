//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI
// Print JSON to Console
func printJSon() {
  let encoder = JSONEncoder()
  encoder.outputFormatting = .prettyPrinted
  if let jsonData = try? encoder.encode(fishData) {
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print(jsonString)
  }
}
@main
struct qandaApp: App {
    var body: some Scene {
        WindowGroup {
          MultiView(qandas: [fishData,dogData,catData,xData,gemData])
            .navigationTitle("20,000 Questions")
        }
    }
}
