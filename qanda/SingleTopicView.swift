//
//  FishQuiz.swift
//  qanda
//
//  Created by bill donner on 4/19/23.
//
import SwiftUI

struct GameData : Codable, Hashable,Identifiable,Equatable {

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
enum Choices {
  case showImage
  case showInfo
  case showScorePage
}
struct SheetChoices:Identifiable {
  let id = UUID()
  let choice:Choices
  let arg: String?
}

struct SingleTopicView: View {
  @StateObject var stv: STV
  let quizData: GameData
  @State var sheetchoice: SheetChoices? = nil
  
  var body: some View {
    //let _ = printJSon()
    NavigationStack {
      let finally = (stv.currentQuestionIndex == quizData.challenges.count-1) && stv.showingAnswer
      let qd = quizData.challenges[stv.currentQuestionIndex]
      VStack {
        Text("Question \(stv.currentQuestionIndex+1)")
          .font(.subheadline)
        Text(qd.question)
          .font(.title).padding()
        ForEach(0 ..< qd.answers.count, id:\.self) { number in
          Button(action: {
            self.checkAnswer(number)
            stv.showingAnswer = true
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
      }
      .navigationBarItems(trailing: Button("\(finally ? "Final " : "")Score: \(stv.score)") {
        sheetchoice = SheetChoices(choice:.showScorePage,arg:"")
      }
        .navigationBarTitle(Text(quizData.subject + "\(finally ? " Finally Done " : "")"))
        .toolbar {
          ToolbarItemGroup(placement: .bottomBar){
            Button(finally ? "Start Over":"Previous") {
              if finally {
                self.startOver()
              } else {
                self.priorQuestion()
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
              self.nextQuestion()
            }
            .disabled(stv.currentQuestionIndex == quizData.challenges.count-1 )
          }
        }// toolbar
      )    .sheet(item:$sheetchoice){sc in
        switch sc.choice {
        case .showImage :
        let _ = print ("will show Image" + (sc.arg ?? "") )
          if let s = sc.arg , let url = URL(string: s) {
            WebView(url:url)
          }
        case .showInfo :
          if let s = sc.arg, let url = URL(string: s) {
           let _ =  print("will show article " + (sc.arg ?? "") )
            WebView(url:url)
          }
        case .showScorePage :
          Text ("will show Scores")
        }
      }
    }
  }
}


struct ImageView: View {
    let imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .clipped()
    }
}

 import WebKit

// generate a View using WKWebView that displays an arbitrary Web page in full screen
// generate a main program to test the view on https://www.apple.com
struct WebView: UIViewRepresentable {

    let url:URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

extension SingleTopicView {
  func checkAnswer(_ number: Int) {
    if quizData.challenges[stv.currentQuestionIndex].answers[number] == quizData.challenges[stv.currentQuestionIndex].answer {
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


struct SingleTopicView_Previews: PreviewProvider {
  static var previews: some View {
    SingleTopicView(stv: STV(),
                    quizData: GameData(subject:"Test",challenges: [
                      Challenge(id: "idstring", question: "question???", topic: "Test Topic", hint: "hint", answers:[ "ans1","ans2"], answer: "ans2", explanation: ["exp1","exp2"], article: "badurl", image: "badurl")]))
  }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
      WebView(url: URL(string:"https://www.apple.com")!)
          .edgesIgnoringSafeArea(.all)
    }
}


struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
      Spacer()
        WebView(url: URL(string:"https://billdonner.com/images/paloaltojul2021.jpg")!)
      Spacer()
       
    }
}
