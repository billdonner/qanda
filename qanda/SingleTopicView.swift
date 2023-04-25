//
//  FishQuiz.swift
//  qanda
//
//  Created by bill donner on 4/19/23.
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
// SwiftUI Code

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
              Spacer()
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
                        .font(.title)
                    Text("Explanation: \(quizData.challenges[currentQuestionIndex].explanation[0])")
                    .font(.headline).padding()
                }
                Spacer()
                Text("\(finally ? "Final " : "")Score: \(score)")
                .font(finally ? .largeTitle:.title)
                
            }
            .navigationBarTitle(Text(quizData.subject + "\(finally ? " Finally Done " : "")"))
            .navigationBarItems(trailing:  Button("Next") {
                    self.nextQuestion()
            }.disabled(currentQuestionIndex == quizData.challenges.count-1))
            .navigationBarItems(leading: Button(finally ? "Start Over":"Previous") {
              if finally {
                self.startOver()
              } else {
                self.priorQuestion()
              }
            }.disabled(currentQuestionIndex == 0))
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
    SingleTopicView(quizData: fishData)
  }
}


//


struct MultiView: View {
  let qandas: [GameData]

  var body: some View {
    NavigationStack { 
     Spacer()
      Text("Choose your game:")
      Spacer()
      VStack {
        ForEach (qandas) { qanda in
          NavigationLink(destination: SingleTopicView(quizData: qanda)) {
            Text(qanda.subject).font(.title)
          }
        }
      }
      .navigationBarTitle("20,000 Questions")
      Spacer()
    }
  }
    
  }

struct MultiView_Previews: PreviewProvider {
  static var previews: some View {
    MultiView(qandas: [fishData,dogData,catData,xData])
      .navigationTitle("20,000 Questions")
  }
}


