//
//  qandaApp.swift
//  qanda
//
//  Created by bill donner on 4/17/23.
//

import SwiftUI

@main
struct qandaApp: App {
    var body: some Scene {
        WindowGroup {
          MultiView(qandas: [fishData,dogData,catData,xData])
            .navigationTitle("20,000 Questions")
        }
    }
}
