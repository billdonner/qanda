//
//  FishQuiz.swift
//  qanda
//
//  Created by bill donner on 4/19/23.
//
import SwiftUI


// SwiftUI Code

class STV : ObservableObject {
  internal init(id: Int = 0, currentQuestionIndex: Int = 0, showingAnswer: Bool = false, score: Int = 0) {
    self.id = id
    self.currentQuestionIndex = currentQuestionIndex
    self.showingAnswer = showingAnswer
    self.score = score
  }
  

  var id:Int = 0
  @Published var currentQuestionIndex: Int
  @Published var showingAnswer: Bool
  @Published var score:Int 
}

struct SingleTopicView: View {
  @StateObject var stv: STV
    let quizData: GameData
  
    var body: some View {
      //let _ = printJSon()
        NavigationStack {
          let finally = (stv.currentQuestionIndex == quizData.challenges.count-1) && stv.showingAnswer
            VStack {
              Text("Question \(stv.currentQuestionIndex+1)")
                    .font(.subheadline)
              Text(quizData.challenges[stv.currentQuestionIndex].question)
                .font(.title).padding()
              ForEach(0 ..< quizData.challenges[stv.currentQuestionIndex].answers.count, id:\.self) { number in
                    Button(action: {
                        self.checkAnswer(number)
                          stv.showingAnswer = true
                    }) {
                        Text("\(self.quizData.challenges[stv.currentQuestionIndex].answers[number])")
                    }
                    .padding()
                }
              if stv.showingAnswer {
                Text("Answer: \(quizData.challenges[stv.currentQuestionIndex].answers[quizData.challenges[stv.currentQuestionIndex].correctAnswer])")
                    .font(.title).padding()
                ForEach ( quizData.challenges[stv.currentQuestionIndex].explanation, id:\.self) {
                  explanation in
                  Text("Explanation:"+explanation).font(.headline).padding()
                }
                }
                Spacer()
            }
            .navigationBarTitle(Text(quizData.subject + "\(finally ? " Finally Done " : "")"))
            .toolbar {
              ToolbarItem(placement:.bottomBar) {
                Button(finally ? "Start Over":"Previous") {
                  if finally {
                    self.startOver()
                  } else {
                    self.priorQuestion()
                  }
                }.disabled(stv.currentQuestionIndex == 0)
              }
              ToolbarItem(placement: .bottomBar){
                Button("Next") {
                        self.nextQuestion()
                }.disabled(stv.currentQuestionIndex == quizData.challenges.count-1)
              }
            }
            .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(stv.score)") {
          
            })
        }
    }

}

struct SingleTopicView_Previews: PreviewProvider {
  static var previews: some View {
    SingleTopicView(stv: STV(), quizData: chatGPT_GENERATED_DATA[0])
  }
}


//

extension SingleTopicView {
  
  func checkAnswer(_ number: Int) {
    if number == quizData.challenges[stv.currentQuestionIndex].correctAnswer {
      stv.score += 1
      }
  }
  
  func nextQuestion() {
    if stv.currentQuestionIndex + 1 < quizData.challenges.count {
      stv.currentQuestionIndex += 1
      stv.showingAnswer = false
      } else {
          // game is over
      }
  }

func priorQuestion() {
  if stv.currentQuestionIndex > 0 {
    stv.currentQuestionIndex -= 1
    stv.showingAnswer = false
    } else {
        // g???
    }
}
func startOver() {
  stv.currentQuestionIndex = 0
  stv.showingAnswer = false
  stv.score = 0
}
}


