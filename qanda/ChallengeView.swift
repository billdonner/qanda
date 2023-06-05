//
//  ChallengeView.swift
//  qanda
//
//  Created by bill donner on 6/4/23.
//

import SwiftUI

struct ChallengeView: View {
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
          if let x = qd.explanation {
            Text("Explanation:" + x).font(.body).padding()
          }
        }
        //        Spacer()
      }// vstack
      .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(stv.score)") {
        sheetchoice = SheetChoices(choice:.showHintBottomSheet,arg:qd.hint)
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
              Image(systemName: "hand.thumbsdown")
            }
            .disabled(qd.image=="" || !stv.showingAnswer)
            Spacer()
            Button {
              sheetchoice = SheetChoices(choice:.showInfo,arg:qd.article)
            } label: {
              Image(systemName: "hand.thumbup")
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
            WebView(url:url)
          }
        case .showInfo :
          if let s = sc.arg, let url = URL(string: s) {
            WebView(url:url)
          }
        case .showScorePage :
          SettingsView(stv:stv)
        case .showHintBottomSheet:
          if let s = sc.arg {
            HintBottomSheetView ( hint: s)
              .presentationDetents([.fraction(0.15)])
          }
        }
      }//sheet
    }
  }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
   
      ChallengeView(gs: GameState(), index: 0, quizData: GameData(subject: "Body Parts", challenges: [Challenge()]))
    }
}