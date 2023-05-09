//
//  FishQuiz.swift
//  qanda
//
//  Created by bill donner on 4/19/23.
//
import SwiftUI

enum GameDataSource : Int {
  
  case localFull // keep first for easiest testing
  case localBundle
  case gameDataSource1
  case gameDataSource2
  
 static  func string(for:Self) -> String {
    switch `for` {
    case .localBundle:
      return "local"
    case .localFull:
      return "localFull"
    case .gameDataSource1:
     return "source1"
    case .gameDataSource2:
      return "source2"
    }
  }
}


// SwiftUI Code

 class GameState : ObservableObject {
   let id:String = UUID().uuidString
   @Published var info:[PerTopicInfo] = []
   @Published var masterScore:Int = 0
  // @Published var masterTopicIndex:Int = 0
}



struct PerTopicInfo {
  var currentQuestionIndex: Int = 0
  var showingAnswer : Bool = false
  var score: Int = 0
}


fileprivate enum Choices {
  case showImage
  case showInfo
  case showScorePage
}
fileprivate struct SheetChoices:Identifiable {
  let id = UUID()
  let choice:Choices
  let arg: String?
}


struct SingleTopicView: View {
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
            if quizData.challenges[stv.currentQuestionIndex].answers[number] == quizData.challenges[stv.currentQuestionIndex].answer {
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
          Text("Answer: \(qd.answer)")
            .font(.title).padding()
          Text("Explanation:" + qd.explanation.map{$0}.joined()).font(.headline).padding()
        }
        //        Spacer()
      }// vstack
      .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(stv.score)") {
        sheetchoice = SheetChoices(choice:.showScorePage,arg:"")
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
              Image(systemName: "photo")
            }
            .disabled(qd.image=="" || !stv.showingAnswer)
            Spacer()
            Button {
              sheetchoice = SheetChoices(choice:.showInfo,arg:qd.article)
            } label: {
              Image(systemName: "info")
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
            let _ = print ("will show Image" + (sc.arg ?? "") )
            WebView(url:url)
          }
        case .showInfo :
          if let s = sc.arg, let url = URL(string: s) {
           let _ =  print("will show article " + (sc.arg ?? "") )
            WebView(url:url)
          }
        case .showScorePage :
          let _ =  print("will show scores " + (sc.arg ?? "") )
          ShowScoresView(stv:stv)
        }
      }//sheet
    }
  }
}


struct SingleTopicView_Previews: PreviewProvider {
  static var previews: some View {
    SingleTopicView(gs:  GameState(), index:0 ,
                    quizData: GameData(subject:"Test",challenges: [
                      Challenge(id: "idstring", question: "question???", topic: "Test Topic", hint: "hint", answers:[ "ans1","ans2"], answer: "ans2", explanation: ["exp1","exp2"], article: "badurl", image: "badurl")]))
  }
}

