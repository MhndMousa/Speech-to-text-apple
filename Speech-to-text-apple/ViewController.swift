//
//  ViewController.swift
//  Speech-to-text-apple
//
//  Created by Muhannad Alnemer on 7/11/19.
//  Copyright © 2019 Muhannad Alnemer. All rights reserved.
//

import UIKit
import Speech
class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch  {
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable{
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.label.text = bestString
            }else if let error = error{
                print(error)
            }
        })
    }
    
    @IBAction func recordButtonClicked(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
}

