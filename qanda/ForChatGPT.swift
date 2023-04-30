import SwiftUI

//PROMPT consider the following structure
struct Challenge :Codable,Hashable,Identifiable,Equatable {
  internal init(id: String, question: String, topic: String, hint: String, answers: [String], answer: String, explanation: [String], article: String, image: String) {
    self.id = id
    self.question = question
    self.topic = topic
    self.hint = hint
    self.answers = answers
    self.answer = answer
    self.explanation = explanation
    self.article = article
    self.image = image
  }
  
  let id : String
  let question: String
  let topic: String
  let hint:String // a hint to show if the user needs help
  let answers: [String]
  let answer: String // which answer is correct
  let explanation: [String] // reasoning behind the correctAnswer
  let article: String // URL of article about the correct Answer
  let image:String // URL of image of correct Answer
}
//let id = "wld date: april 29,2003 9:52AM"
// generate THREE challenges as an array of JSON about "Fun Fish Facts"
//let json_challenges = [

