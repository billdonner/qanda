import SwiftUI

/* write a QandAView View to display the qandas on separate pages, showing the correct answer in blue and the question in a larger font
 put the subject as a  title up on top in a navigation bar
write a ContentView View supplying data to QandAView
write a Preview for ContentView
*/

struct QandAView: View {
  let qanda: Challenge
  
  var body: some View {
    VStack{
      Text(qanda.question).font(.title).padding()
      ForEach(0..<qanda.answers.count, id: \.self) { number in
        Text(qanda.answers[number])
          .foregroundColor(number == qanda.correctAnswer ? Color.blue : Color.primary)
      }
      ForEach(qanda.explanation, id: \.self) { explanation in
        Text(explanation).padding()
      }
    }
  }
}

struct ContentView: View {
  let qandas: GameData
  
  var body: some View {
    NavigationView {
      List {
        Text(qandas.subject).font(.title).padding()
        ForEach(qandas.challenges, id: \.self) { qanda in
          NavigationLink(destination: QandAView(qanda: qanda)) {
            Text(qanda.question)
          }
        }
      }
    .navigationBarTitle("Questions")
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView(qandas: gameData)
//  }
//}

//////////// PASTE BELOW HERE ///////////////
