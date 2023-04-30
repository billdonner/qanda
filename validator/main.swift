import Foundation

struct Challenge :Codable {
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
// generate a swift command line program to read and count byes in JSON encoded Challenge arrays



func main() {
  var count : Int = 0
  var bytesRead : Int = 0
  var topics: [String:Int] = [:]
  var dupeQustions: [String:Int] = [:]
  
  // Get the list of URLs from the command line arguments.
  let urls = CommandLine.arguments[1...]
  
  // Iterate over the URLs and count the bytes read at each URL.
  for url in urls {
    // Get the data from the URL.
    
    guard let u = URL(string:url) else {
      print("Cant read url \(url)")
      continue
    }
    do {
      let data = try Data(contentsOf: u)
      bytesRead = data.count
      
      // Decode the data, which means converting data to Swift objects.
      do {
        let challenges = try JSONDecoder().decode([Challenge].self, from: data)
        count = challenges.count
        for challenge in challenges {
          let key = challenge.topic
          if let topic =  topics [key] {
            topics [key] = topic + 1
          } else {
            topics [key ] = 1 // a new one
          }
          let qkey = challenge.question
          if let q =  dupeQustions [qkey] {
            dupeQustions [qkey] = q + 1
          } else {
            dupeQustions [qkey ] = 1 // a new one
          }
        }
        // At the end of each url, Print the bytes read and topics
        print("Read \(url) - \(bytesRead) bytes, \(count) challenges")
        
      }
      catch {
        print("Could not decode \(u)", error)
      }
    }
    catch {
      print("Can't read contents of \(url)" )
      continue
    }
    
  } // topics
  for (_, key_value) in topics.enumerated() {
    let (key,value) = key_value
    print("Topic - \(key), \(value) challenges")
  }
  // duplicates
  for (_, key_value) in  dupeQustions.enumerated() {
    let (key,value) = key_value
    if value > 1 {
      print("Duplicate Question - \(key), \(value) dupes")
    }
  }
}

if CommandLine.argc == 1 {
  print("Usage: count-bytes <url>...")
  exit(1)
}

main()
