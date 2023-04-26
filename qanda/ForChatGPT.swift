import SwiftUI

struct Challenge : Hashable, Codable {
  internal init(question: String, answers: [String], correctAnswer: Int, explanation: [String], article: String? = nil, image: String? = nil) {
    self.question = question
    self.answers = answers
    self.correctAnswer = correctAnswer
    self.explanation = explanation
    self.article = article
    self.image = image
  }
  
  let question: String
  let answers: [String]
  let correctAnswer: Int // index into answers of the single correct answer
  let explanation: [String] // reasoning behind the correctAnswer
  let article: String? // URL of article about the correct Answer
  let image:String? // URL of image of correct Answer
}

struct GameData : Codable, Hashable,Identifiable {
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
