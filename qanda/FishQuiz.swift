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

struct FishQuiz: View {
    @State private var currentQuestionIndex = 0
    @State private var showingAnswer = false
    @State private var score = 0
    
    let quizData: GameData
    
    var body: some View {
      //let _ = printJSon()
        NavigationView {
          
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
            .navigationBarItems(leading: Button(finally ? "Start Over":"Back") {
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
struct FishQuiz_Previews: PreviewProvider {
  static var previews: some View {
    FishQuiz(quizData: fishData)
  }
}

// Generate GameData with TWENTY Challenges about FISH

// Generate additional SwiftUI code  and Preview to implement Fish Quiz Challenge: A quiz game in which the player is asked questions about different types of fish. The player must answer the questions correctly in order to progress and earn points.

let fishData = GameData(subject: "Fishy Fun", challenges: [
  Challenge(question: "Which of these fish is not a type of eel?",
  answers: ["Moray", "Conger", "Snapper", "Angler"],
  correctAnswer: 2,
  explanation: ["Snapper is a type of fish, but not a type of eel."]),
  Challenge(question: "What is the largest species of fish in the world?",
  answers: ["Tiger Shark", "Great White Shark", "Whale Shark", "Giant Oarfish"],
  correctAnswer: 2,
  explanation: ["Whale shark is the largest species of fish in the world, reaching up to 40 feet in length."]),
  Challenge(question: "Which of these fish can change color?",
  answers: ["Guppy", "Tuna", "Catfish", "Stingray"],
  correctAnswer: 0,
  explanation: ["Guppies can change color to blend in with their environment, helping them avoid predators."]),
  Challenge(question: "Which of these fish is a carnivore?",
  answers: ["Sturgeon", "Halibut", "Grouper", "Gar"],
  correctAnswer: 3,
  explanation: ["Gar are carnivorous fish that hunt for other fish, insects, and crustaceans."]),
  Challenge(question: "What is the smallest species of fish in the world?",
  answers: ["Pygmy Goby", "Paedocypris progenetica", "Tadpole Fish", "Dwarf Goby"],
  correctAnswer: 1,
  explanation: ["Paedocypris progenetica is the smallest species of fish in the world, reaching a maximum size of just 7.9mm."]),
  Challenge(question: "Which of these fish can be found in the deepest parts of the ocean?",
  answers: ["Grunion", "Tuna", "Lanternfish", "Tadpole Fish"],
  correctAnswer: 2,
  explanation: ["Lanternfish are found in the deepest parts of the ocean, up to 6,000 meters below the surface."]),
  Challenge(question: "Which of these fish produces a powerful electric shock?",
  answers: ["Piranha", "Electric Eel", "Lionfish", "Goblin Shark"],
  correctAnswer: 1,
  explanation: ["Electric eels are capable of producing a powerful electric shock, up to 860 volts."]),
  Challenge(question: "Which of these fish is the fastest swimmer?",
  answers: ["Mahi-mahi", "Swordfish", "Sailfish", "Tuna"],
  correctAnswer: 2,
  explanation: ["Sailfish are the fastest swimmers, reaching speeds of up to 110 kilometers per hour."]),
  Challenge(question: "Which of these fish is an apex predator?",
  answers: ["Tuna", "Barracuda", "Grunion", "Trout"],
  correctAnswer: 1,
  explanation: ["Barracudas are apex predators, meaning they are at the top of the food chain and have no natural predators."]),
  Challenge(question: "Which of these fish lays the most eggs?",
  answers: ["Piranha", "Sturgeon", "Mahi-mahi", "Salmon"],
  correctAnswer: 2,
  explanation: ["Mahi-mahi can lay up to 2 million eggs at once, making them the fish that lays the most eggs."]),
  Challenge(question: "Which of these fish has the longest lifespan?",
  answers: ["Guppy", "Tuna", "Grouper", "Sturgeon"],
  correctAnswer: 3,
  explanation: ["Sturgeon can live up to 150 years, making them the fish with the longest lifespan."]),
  Challenge(question: "Which of these fish can breathe air?",
  answers: ["Shark", "Piranha", "Catfish", "Tilapia"],
  correctAnswer: 2,
  explanation: ["Catfish are able to breathe air, allowing them to survive in low-oxygen environments."]),
  Challenge(question: "Which of these fish can live in both fresh and saltwater?",
  answers: ["Salmon", "Tuna", "Mullet", "Barracuda"],
  correctAnswer: 0,
  explanation: ["Salmon are able to live in both fresh and saltwater, allowing them to migrate between habitats."]),
  Challenge(question: "Which of these fish is the most intelligent?",
  answers: ["Tuna", "Grouper", "Pufferfish", "Clownfish"],
  correctAnswer: 1,
  explanation: ["Grouper are considered to be the most intelligent fish, exhibiting complex behaviors such as problem solving and tool use."]),
  Challenge(question: "Which of these fish is a bottom-dweller?",
  answers: ["Barracuda", "Catfish", "Mahi-mahi", "Tuna"],
  correctAnswer: 1,
  explanation: ["Catfish are bottom-dwellers, meaning they spend most of their time near the bottom of the water column."]),
  Challenge(question: "Which of these fish can change sex?",
  answers: ["Piranha", "Goby", "Grunion", "Clownfish"],
  correctAnswer: 3,
  explanation: ["Clownfish are able to change sex, meaning they can switch from male to female or vice versa."]),
  Challenge(question: "Which of these fish is the most venomous?",
  answers: ["Toadfish", "Stonefish", "Lionfish", "Grouper"],
  correctAnswer: 1,
  explanation: ["Stonefish are the most venomous fish, capable of delivering a deadly sting with their spines."]),
  Challenge(question: "Which of these fish can survive out of water?",
  answers: ["Tilapia", "Guppy", "Trout", "Mudskipper"],
  correctAnswer: 3,
  explanation: ["Mudskippers are able to survive out of water for extended periods of time, allowing them to move around on land."]),
  Challenge(question: "Which of these fish is the longest living vertebrate?",
  answers: ["Lingcod", "Tuna", "Sturgeon", "Grouper"],
  correctAnswer: 2,
  explanation: ["Sturgeon are the longest living vertebrates, with some individuals living up to 150 years."]),
  Challenge(question: "Which of these fish is the fastest growing?",
  answers: ["Tilapia", "Salmon", "Trout", "Catfish"],
  correctAnswer: 0,
  explanation: ["Tilapia is the fastest growing fish, reaching maturity in just a few months and growing up to 1 meter in length."])
])

