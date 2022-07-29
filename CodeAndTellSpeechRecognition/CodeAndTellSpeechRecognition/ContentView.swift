//
//  ContentView.swift
//  CodeAndTellSpeechRecognition
//
//  Created by Kelsey Sparkman on 7/28/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: SpeechViewModel
    
    var body: some View {
        Button {
            /*
             Step 1: Check for permissions
             - add NSSpeechRecognitionUsageDescription to info.plist
             
             Step 2: Begin dictation
            */
        } label: {
            Text("Start Speech Dictation")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 20)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
