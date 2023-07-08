//
//  ChallengeView.swift
//  qanda
//
//  Created by bill donner on 6/4/23.
//

import SwiftUI
import q20kshare

struct SoloTopicView: View {
  @StateObject var gs: GameState
  let topicIndex:Int
  let gameData: GameData
  
  @State  private var sheetchoice: SheetChoices? = nil
  

  var body: some View {
    NavigationStack {
      let topicState = gs.topicState[topicIndex]
      let finally = (topicState.currentQuestionIndex == gameData.challenges.count-1) && topicState.showingAnswer
      let qd = gameData.challenges[topicState.currentQuestionIndex]
      
      makeChallengeSubview(gs: gs,quizData: gameData,topicInfo:topicState)
        .navigationBarTitle(Text(gameData.subject + "\(finally ? " Finally Done " : "")"))
      
        .navigationBarItems(trailing: Button("\(finally ? "Final " : "") Score: \(topicState.score)") {
          hintButtonPressed(hint:qd.hint)
        }
                            
          .toolbar {
            ToolbarItemGroup(placement: .bottomBar){
              Button(finally ? "Start Over":"Previous") {
                previousButtonPressed(finally: finally)
              }
              .disabled(topicState.currentQuestionIndex <= 0)
              
              Button {
                thumbsDownButtonPressed()
              } label: {
                Image(systemName: "hand.thumbsdown")
              }
              .disabled(  !topicState.showingAnswer)
              
              Spacer()
              Button {
                thumbsUpButtonPressed()
              } label: {
                Image(systemName: "hand.thumbsup")
              }
              .disabled( !topicState.showingAnswer)
              
              Button("Next") {
                nextButtonPressed(max: gameData.challenges.count)
              }
              .disabled(topicState.currentQuestionIndex >= gameData.challenges.count-1 )
            }
          }// toolbar
        )
        .sheet(item:$sheetchoice){sc in
          switch sc.choice {
          case .thumbsUp(let challenge) :
            ThumbsUpView(challenge:challenge)
          case .thumbsDown(let challenge) :
            ThumbsDownView(challenge:challenge)
          case .showChallengeInfoPage(let challenge):
            ChallengeInfoPageView(challenge:challenge)
          case .showScorePage :
            SettingsView(stv:topicState)
          case .showHintBottomSheet(let s):
            HintBottomSheetView ( hint: s)
              .presentationDetents([.fraction(0.15)])
          }
        }
    }//sheet
  }
}

struct ChallengeView_Previews: PreviewProvider {
  static var previews: some View {
    let challenge = Challenge(question: "Why is the sky blue", topic: "Nature", hint: "It's not green", answers: ["good","bad","ugly"], correct: "good")
    
    SoloTopicView(gs: GameState(), topicIndex: 0, gameData: GameData(subject: "Natural Things", challenges: [challenge]))
  }
}
extension SoloTopicView {
  func makeChallengeSubview(gs:GameState,
                            quizData:GameData ,
                            topicInfo:TopicState)-> some View {
    let qd = quizData.challenges[topicInfo.currentQuestionIndex]
    return  VStack {
      HStack{
        Text("Question \(topicInfo.currentQuestionIndex+1)")
          .font(.subheadline)
        Spacer()
        Button(action: infoButtonPressed) {
          Image(systemName: "info.circle")
        }
        
      }.padding()
      ScrollView {
        HStack{
          Text(qd.question)
            .font(.title).padding()
   
        }
        ForEach(0 ..< qd.answers.count, id:\.self) { number in
          Button(action:{playAndScore(number)}) {
            Text("\(qd.answers[number])")
          }
          .padding()
        }
        if topicInfo.showingAnswer {
          Text("Answer: \(qd.correct)")
            .font(.title).padding()
          if let x = qd.explanation {
            Text("Explanation:" + x).font(.body).padding()
          }
        }
      }//scroll
    }// vstack
  }
}

extension SoloTopicView {
  func previousButtonPressed(finally:Bool) {
    if finally {
      gs.topicState[topicIndex].currentQuestionIndex = 0
      gs.topicState[topicIndex].showingAnswer = false
      gs.topicState[topicIndex].score = 0
    } else {
      if gs.topicState[topicIndex].currentQuestionIndex > 0 {
        gs.topicState[topicIndex].currentQuestionIndex -= 1
        gs.topicState[topicIndex].showingAnswer = false
      }
    }
  }
  func nextButtonPressed(max:Int) {
    if gs.topicState[topicIndex].currentQuestionIndex + 1 < max {
      gs.topicState[topicIndex].currentQuestionIndex += 1
      gs.topicState[topicIndex].showingAnswer = false
    }
  }
  func thumbsDownButtonPressed(){
    let ts =  gs.topicState[topicIndex]
    sheetchoice = SheetChoices(choice:.thumbsDown(gameData.challenges[ts.currentQuestionIndex]))
  }
  
  func thumbsUpButtonPressed(){
    let ts =  gs.topicState[topicIndex]
    sheetchoice = SheetChoices(choice:.thumbsUp(gameData.challenges[ts.currentQuestionIndex]))
  }
  func hintButtonPressed(hint:String){
    sheetchoice = SheetChoices(choice:.showHintBottomSheet(hint))
  }
  func playAndScore(_ possibleAnswerIndex:Int) { 
    let cqi = gs.topicState[topicIndex].currentQuestionIndex
     if gameData.challenges[cqi].answers[possibleAnswerIndex] == gameData.challenges[cqi].correct {
       // in the case of a correct answer bump scores
       gs.topicState[topicIndex].score += 1
       gs.masterScore += 1
     }
    gs.topicState[topicIndex].showingAnswer = true
   }
  func infoButtonPressed () {
    let ts =  gs.topicState[topicIndex]
    sheetchoice = SheetChoices(choice:.showChallengeInfoPage(gameData.challenges[ts.currentQuestionIndex]))
  }
}
