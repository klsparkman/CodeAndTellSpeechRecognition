//
//  SpeechViewModel.swift
//  CodeAndTellSpeechRecognition
//
//  Created by Kelsey Sparkman on 7/29/22.
//

import SwiftUI
import Speech

class SpeechViewModel: ObservableObject {
    
    @State var recordButtonActive: Bool = false
    let speech: [String] = []
    
    func requestPermission(completion: (String) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    return self.recordButtonActive = true
                case .denied:
                    return self.recordButtonActive = false
                    // user denied access - show alert
                case .restricted:
                    return self.recordButtonActive = false
                    // speech recognition restricted - show alert
                case .notDetermined:
                    return self.recordButtonActive = false
                    // speech recognition not yet authorized - show alert
                @unknown default:
                    debugPrint("Fatal Error")
                }
            }
        }
    }
    
    func recognizeAudio(completion: (String) -> Void) {
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechRecognitionRequest()
        recognizer?.recognitionTask(with: request, resultHandler: { result, error in
            guard let result = result else {
                debugPrint("Error with speech regognition: \(String(describing: error))")
                return
            }
            
            result.bestTranscription.formattedString
        })
    }
}
