//
//  SupportViews.swift
//  qanda
//
//  Created by bill donner on 4/30/23.
//

import SwiftUI

import WebKit

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

struct SupportViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SupportViews_Previews: PreviewProvider {
    static var previews: some View {
        SupportViews()
    }
}
