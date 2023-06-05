//
//  HintBottomSheetView.swift
//  qanda
//
//  Created by bill donner on 6/4/23.
//

import SwiftUI

struct HintBottomSheetView : View {
  let hint:String
  var body: some View {
    VStack {
      Image(systemName:"line.3.horizontal.decrease")
      Spacer()
      HStack{
        //Text("Hint:").font(.title3)
        Text(hint).font(.largeTitle)
      }
      Spacer()
    }
    .frame(maxWidth:.infinity)
    .background(Color(white: 0.7))
    .ignoresSafeArea()
  }
  
}
struct HintBottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    HintBottomSheetView(hint: "Take it slow")
  }
  
}
