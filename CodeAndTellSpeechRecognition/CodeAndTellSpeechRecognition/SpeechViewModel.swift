//
//  SpeechViewModel.swift
//  CodeAndTellSpeechRecognition
//
//  Created by Kelsey Sparkman on 7/29/22.
//

import Speech
import SwiftUI

class SpeechViewModel: ObservableObject {
    
    @Published var recordButtonActive: Bool = false
    @Published var speech: String = ""
    @Published var isListening: Bool = false
    @Published var dictationHasBeenCleared: Bool = false
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    
    init() {
        inputNode = nil
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButtonActive = true
                    
                case .denied:
                    self.recordButtonActive = false
                    // Display alert
                    
                case .restricted:
                    self.recordButtonActive = false
                    // Display alert
                    
                case .notDetermined:
                    self.recordButtonActive = false
                    // Display alert
                    
                default:
                    self.recordButtonActive = false
                }
            }
        }
    }
    
    func startRecording() throws {
        // cancel previos task if it's running
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // configure the audio session for the app
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        self.inputNode = audioEngine.inputNode
        
        // create and configure the speech recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecoognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // create recognition task for the speech recognition session
        // keep a reference to the task so that it can be cancelled
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            var isFinal = false
            
            if error != nil || isFinal {
                // stop recognizing speech if there is a problem
                self.audioEngine.stop()
                if let node = self.inputNode {
                    node.removeTap(onBus: 0)
                }
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordButtonActive = true
            }
            
            if let result = result {
                // update the text view with results
                self.speech = result.bestTranscription.formattedString
                isFinal = result.isFinal
                debugPrint("Text: \(result.bestTranscription.formattedString)")
            }
        })
        
        // configure the microphone input
        let recordingFormat = self.inputNode?.outputFormat(forBus: 0)
        self.inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        
        // let the user know to start talking
        self.isListening = true
    }
    
    func handleRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            isListening = false
            self.inputNode?.removeTap(onBus: 0)
        } else {
            do {
                try startRecording()
                self.isListening = true
            } catch {
                debugPrint("Recording not available: \(error)")
            }
        }
    }
    
    func clearDictation() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isListening = false
        speech = ""
        dictationHasBeenCleared = true
    }
}
