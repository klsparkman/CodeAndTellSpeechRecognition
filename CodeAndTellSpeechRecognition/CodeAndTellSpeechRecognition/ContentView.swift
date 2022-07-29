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
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Button {
                    viewModel.handleRecording()
                } label: {
                    Text(viewModel.isListening ? "Stop Speech Dictation" : "Start Speech Dictation")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .disabled(!viewModel.recordButtonActive)
                .opacity(viewModel.recordButtonActive ? 1 : 0.5)
                .foregroundColor(.white)
                .background(Color.blue)
                .frame(maxWidth: .infinity, maxHeight: 50)
                
                Text(viewModel.speech)
                    .frame(maxWidth: .infinity, maxHeight: 500, alignment: .topLeading)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 0))
                    .foregroundColor(.black)
                    .background(Color.secondary)
                
                Button {
                    viewModel.clearDictation()
                } label: {
                    Text("Clear Dictation")
                        .frame(maxWidth: 200, maxHeight: 30)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
            }
            .padding(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SpeechViewModel())
    }
}
