//RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Maram Moh on 11/09/1441 AH.
//  Copyright © 1441 Maram Moh. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    func configureUI(isRecording: Bool) {
           stopRecordingButton.isEnabled = isRecording // to disable the button
           recordButton.isEnabled = !isRecording // to enable the button
           recordingLable.text = !isRecording ? "Tap to Record" : "Recording in Progress"

       }

    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
//        recordingLable.text = "Recording in Progress"
//        stopRecordingButton.isEnabled=true
//        recordButton.isEnabled=false

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))

            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate=self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
//        recordButton.isEnabled=true
//        stopRecordingButton.isEnabled=false
//        recordingLable.text="Tap to Record"
        audioRecorder.stop()
          let audioSession = AVAudioSession.sharedInstance()
          try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
        else{
            print("recording was not successful")
        }
}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let PlaySoundsVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            PlaySoundsVC.recordedAudioURL=recordedAudioURL
        }
    }
}
