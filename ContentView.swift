//
//  ContentView.swift
//  Dragonfly for ACL
//
//  Created by Gabe Hughes on 9/30/19.
//  Copyright © 2019 Gabe Hughes. All rights reserved.
//

import SwiftUI
import WebKit
import MapKit

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            ACLScheduleView()
                .padding(.leading)
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "calendar.circle")
                        Text("ACL Schedule")
                    }
                }
                .tag(0)
            UserScheduleView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "star.circle")
                        Text("My Schedule")
                    }
                }
                .tag(1)
            MapView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("Map")
                    }
                }
            .tag(3)
            InformationView()
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "lightbulb")
                        Text("Information")
                    }
                }
                .tag(2)
        }
    }
}

struct ACLScheduleView: View {
    var body: some View {
        VStack{
            Text("ACL Schedule")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            ScrollView{
                ArtistView()
            }
        }
    }
}

struct UserScheduleView: View {
    var body: some View {
        VStack{
            Text("My Schedule")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            ScrollView{
                Text("Text here")
            }
        }
    }
}

struct InformationView: View {
    var body: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.aclfestival.com/information/")!));
    }
}

struct WebView: UIViewRepresentable {

    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView();
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request);
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
