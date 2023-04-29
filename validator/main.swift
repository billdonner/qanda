import Foundation

//PROMPT consider the following structure
struct Challenge :Codable {
 let id : String
  let question: String
  let question_number: Int
  let topic: String
  let hint:String // a hint to show if the user needs help
  let answers: [String]
  let correctAnswer: Int // index into answers of the single correct answer
  let explanation: [String] // reasoning behind the correctAnswer
  let article: String // URL of article about the correct Answer
  let image:String // URL of image of correct Answer
}
let id = "wld date: april 29,2003 9:52AM"
// generate a swift command line program to read and count byes in JSON encoded Challenge arrays



func main() {
  var count : Int = 0
  // Get the list of URLs from the command line arguments.
  let urls = CommandLine.arguments[1...]

  // Iterate over the URLs and count the bytes read at each URL.
  for url in urls {
    // Get the data from the URL.
    
    guard let u = URL(string:url), let data = try? Data(contentsOf: u) else { //tweaked
      print("Cant read url \(url)")
      continue
    }

    // Decode the data, which means converting data to Swift objects.
    do {
      let challenges = try JSONDecoder().decode([Challenge].self, from: data)
      count = challenges.count
    }
    catch {
      print("Could not decode \(u)")
    }

    // Count the bytes read.
    let bytesRead = data.count

    // Print the bytes read.
    print("Read \(bytesRead) bytes , \(count) challenges from \(url)")
  }
}

if CommandLine.argc == 1 {
  print("Usage: count-bytes <url>...")
  exit(1)
}

main()
