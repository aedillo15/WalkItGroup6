//
//  ContentView.swift
//  WatchApp WatchKit Extension
//
//  Created by user on 2021-12-05.
//

import SwiftUI

struct ContentView: View {
    
    //@EnvironmentObject var locationHelper : LocationHelper
    @State private var tokenCount: Int = 0

    var body: some View {
        VStack{
            Text("Current tokens: \(self.tokenCount)")
                .font(.system(size: 10))
                .foregroundColor(.red)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
