//
//  ThumbsView.swift
//  qanda
//
//  Created by bill donner on 7/7/23.
//

import SwiftUI
import q20kshare

struct ThumbsUpView: View {
  let challenge:Challenge
  @Environment(\.dismiss) var dismiss
  @State private var isOn0 = false
  @State private var isOn1 = false
  @State private var isOn2 = false
  @State private var isOn3 = false
  @State private var freeForm = ""
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Text(challenge.question).foregroundStyle(.blue).font(.headline)
          Text("Glad you enjoyed this Challenge. Please let us know why you liked it. Select all that apply:").padding([.top,.bottom])
        }
        Section {
          Toggle(isOn: $isOn0) {
            Text("It was clever")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn1) {
            Text("It was easy")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn2) {
            Text("It was hard")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn3) {
            Text("It was mind-bening")
          }.toggleStyle(.switch)
        }
        Section {
          Text("If you'd like to communicate your thoughts directly, please enter them here:").padding([.top])
          TextField("don't be shy", text: $freeForm,axis:.vertical)
            .textFieldStyle(.roundedBorder)
        }
      }.padding([.top])
      .navigationBarItems(trailing:     Button {
        // send upstream
        dismiss()
      } label: {
        Text("Submit")
      })
      .navigationBarItems(leading:     Button {
        dismiss()
      } label: {
        Text("Cancel")
      })
      .navigationTitle("Thumbs Up")
    }
  }
}

struct ThumbsUpView_Previews: PreviewProvider {
  static var previews: some View {
    let ch = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good")
    ThumbsUpView(challenge: ch)
  }
}

struct ThumbsDownView: View {
  let challenge:Challenge
  @Environment(\.dismiss) var dismiss
  @State private var isOn0 = false
  @State private var isOn1 = false
  @State private var isOn2 = false
  @State private var isOn3 = false
  @State private var freeForm = ""
  var body: some View {
    NavigationStack {
      Form {
        Section {
          Text(challenge.question).foregroundStyle(.red).font(.headline)
          Text("Sorry you didn't like this Challenge.  Please let us know why you disliked it . Select all that apply:").padding([.top,.bottom])
        }
        Section {
          Toggle(isOn: $isOn0) {
            Text("It is inaccurate")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn1) {
            Text("It is too easy")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn2) {
            Text("It is too hard")
          }.toggleStyle(.switch)
          Toggle(isOn: $isOn3) {
            Text("It is irrelevant to the topic")
          }.toggleStyle(.switch)
        }
        Section {
          Text("If you'd like to communicate your thoughts directly, please enter them here:").padding([.top])
          TextField("don't be shy", text: $freeForm,axis:.vertical)
            .textFieldStyle(.roundedBorder)
        }
      }.padding([.top])
      .navigationBarItems(trailing:     Button {
        // send upstream
        dismiss()
      } label: {
        Text("Submit")
      })
      .navigationBarItems(leading:     Button {
        dismiss()
      } label: {
        Text("Cancel")
      })
      .navigationTitle("Thumbs Down")
    }
  }
}


struct ThumbsDownView_Previews: PreviewProvider {
  //    static var previews: some View {
  //   let challenge = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good")
  //
  //      ChallengeView(gs: GameState(), index: 0, quizData: GameData(subject: "Natural Things", challenges: [challenge]))
  //    }
  static var previews: some View {
    let ch = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good")
    ThumbsDownView(challenge:ch)
  }
}
