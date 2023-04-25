import SwiftUI

struct Challenge : Hashable, Codable {
  let question: String
  let answers: [String]
  let correctAnswer: Int // index into answers of the single correct answer
  let explanation: [String] // reasoning behind the correctAnswer
}

struct GameData : Codable, Identifiable {
  internal init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges.shuffled()  //randomize
    self.id = UUID().uuidString
    self.generated = Date()
  }
  
  let id : String
  let subject: String
  let challenges: [Challenge]
  let generated: Date
}



// Generate additional SwiftUI code to implement Fish Quiz Challenge: A quiz game in which the player is asked questions about different types of fish. The player must answer the questions correctly in order to progress and earn points.
