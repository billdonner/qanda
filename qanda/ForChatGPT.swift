import SwiftUI

//PROMPT consider the following structure
struct Challenge :Codable,Equatable,Hashable {
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
let id = "wld date: april 29,2003 9:52AM"
// generate THREE challenges as an array of JSON about "Fun Fish Facts"
//let json_challenges = [

struct GameData : Codable, Hashable,Identifiable {

  
  internal init(subject: String, challenges: [Challenge]) {
    self.subject = subject
    self.challenges = challenges //.shuffled()  //randomize
    self.id = UUID().uuidString
    self.generated = Date()
  }
  
  let id : String
  let subject: String
  let challenges: [Challenge]
  let generated: Date
}
