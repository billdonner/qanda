import Foundation


let writeOutputFile = true


// generate a swift command line program to read and count byes in JSON encoded Challenge arrays
var count : Int = 0
var bytesRead : Int = 0
var topicCounts: [String:Int] = [:]
var dupeCounts: [String:Int] = [:]

func writeJSONFile(_ urls:[String], outurl:URL)
{
  var allChallenges:[Challenge] = []
  //  guard let outurl = URL(string :tourl) else {
  //    print ("cant write to \(tourl)")
  //    return
  //  }
  for url in urls {
    // read all the urls again
    guard let u = URL(string:url) else {
      print("Cant read url \(url)")
      continue
    }
    do {
      let data = try Data(contentsOf: u)
      let cha = try JSONDecoder().decode([Challenge].self, from: data)
      var removalIndices:[Int] = []
  
      for (index,challenge) in cha.enumerated(){
        // check if its a dupe
        let qkey = challenge.question
        if let q =  dupeCounts [qkey] {
          if q > 1 {
            dupeCounts [qkey] = q - 1
            removalIndices .append (index)
            //print("will remove at \(index) \(qkey)")
          } else {
            // last remaining entry  so dont remove it
            if q==0 { print("makes no sense")  }
            else {
             // print("keeping at \(index) \(qkey)")
            }
          }
        }
      }
      for (idx,chal) in cha.enumerated() {
        if !removalIndices.contains(idx) {
          allChallenges.append(chal)
        }
      }
    }
    catch {
      print("Could not read \(u)")
    }
    
  }
  // write Challenges as JSON to file
  let encoder = JSONEncoder()
  encoder.outputFormatting = .prettyPrinted
  do {
    let data = try encoder.encode(allChallenges)
    let json = String(data:data,encoding: .utf8)
    if let json  {
      try json.write(to: outurl, atomically: false, encoding: .utf8)
      print("Wrote \(json.count) bytes, \(allChallenges.count) challenges to \(outurl)")
    }
  }
  catch {
    print ("Can't write output \(error)")
  }
  
}

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
  
  if writeOutputFile {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    writeJSONFile (Array(urls), outurl: path.appendingPathComponent("full.json"))
  }
}


if CommandLine.argc == 1 {
  print("Usage: count-bytes <url>...")
  exit(1)
}
main()
exit(0)
