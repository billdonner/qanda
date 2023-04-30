import Foundation





// generate a swift command line program to read and count byes in JSON encoded Challenge arrays
var count : Int = 0
var bytesRead : Int = 0
var topicCounts: [String:Int] = [:]
var dupeCounts: [String:Int] = [:]

func analyze(_ urls:[String]) {
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
          if let topic =  topicCounts [key] {
            topicCounts [key] = topic + 1
          } else {
            topicCounts [key ] = 1 // a new one
          }
          let qkey = challenge.question
          if let q =  dupeCounts [qkey] {
            dupeCounts [qkey] = q + 1
          } else {
            dupeCounts [qkey ] = 1 // a new one
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
  for (_, key_value) in topicCounts.enumerated() {
    let (key,value) = key_value
    print("Topic - \(key), \(value) challenges")
  }
  // duplicates
  for (_, key_value) in  dupeCounts.enumerated() {
    let (key,value) = key_value
    if value > 1 {
      print("Duplicate Question - \(key), \(value) dupes")
    }
  }
}


func main() {
  
  let urls = CommandLine.arguments[1...]

  // Get the list of URLs from the command line arguments.
  analyze(Array(urls))
}

if CommandLine.argc == 1 {
  print("Usage: count-bytes <url>...")
  exit(1)
}

main()
