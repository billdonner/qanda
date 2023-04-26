//
//  FishQuiz.swift
//  qanda
//
//  Created by bill donner on 4/19/23.
//
import SwiftUI


// SwiftUI Code

class STV : ObservableObject {
  @Published var currentQuestionIndex = 0
  @Published  var showingAnswer = false
  @Published  var score = 0
}

struct SingleTopicView: View {
    @State private var currentQuestionIndex = 0
    @State private var showingAnswer = false
    @State private var score = 0
    
    let quizData: GameData
  
    var body: some View {
      //let _ = printJSon()
        NavigationStack {
        let finally = (currentQuestionIndex == quizData.challenges.count-1) && showingAnswer
            VStack {
                Text("Question \(currentQuestionIndex+1)")
                    .font(.subheadline)
                Text(quizData.challenges[currentQuestionIndex].question)
                .font(.title).padding()
              ForEach(0 ..< quizData.challenges[currentQuestionIndex].answers.count, id:\.self) { number in
                    Button(action: {
                        self.checkAnswer(number)
                        self.showingAnswer = true
                    }) {
                        Text("\(self.quizData.challenges[self.currentQuestionIndex].answers[number])")
                    }
                    .padding()
                }
                if showingAnswer {
                    Text("Answer: \(quizData.challenges[currentQuestionIndex].answers[quizData.challenges[currentQuestionIndex].correctAnswer])")
                    .font(.title).padding()
                    Text("Explanation: \(quizData.challenges[currentQuestionIndex].explanation[0])")
                    .font(.headline).padding()
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
                }.disabled(currentQuestionIndex == 0)
              }
              ToolbarItem(placement: .bottomBar){
                Button("Next") {
                        self.nextQuestion()
                }.disabled(currentQuestionIndex == quizData.challenges.count-1)
              }
            }
            .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(score)") {
          
            })
        }
    }
    
    func checkAnswer(_ number: Int) {
        if number == quizData.challenges[currentQuestionIndex].correctAnswer {
            score += 1
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex + 1 < quizData.challenges.count {
            currentQuestionIndex += 1
            showingAnswer = false
        } else {
            // game is over
        }
    }
  
  func priorQuestion() {
    if currentQuestionIndex > 0 {
          currentQuestionIndex -= 1
          showingAnswer = false
      } else {
          // g???
      }
  }
  func startOver() {
          currentQuestionIndex = 0
          showingAnswer = false
          score = 0
  }
}

struct SingleTopicView_Previews: PreviewProvider {
  static var previews: some View {
    SingleTopicView(quizData: chatGPT_GENERATED_DATA[0])
  }
}


//




