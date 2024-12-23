//
//  ContentView.swift
//  Dialog2
//
//  Created by primproud on 12/12/2567 BE.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to the App")
                    .font(.largeTitle)
                    .padding()

                // Button to navigate to Simple Method
                NavigationLink(destination: SimpleMethodView()) {
                    Text("Go to Simple Method")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Button to navigate to Comprehensive Method
                NavigationLink(destination: ComprehensiveMethodView()) {
                    Text("Go to Comprehensive Method")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: MainPageView()) {
                    Text("Go to fucking login fuck u")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                    .cornerRadius(10)}
                
                
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
