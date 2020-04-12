//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by msuzuki on 2/19/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    //MARK: - Variables
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    //MARK: - Initial Screen Load
    override func viewDidLoad() {
        super.viewDidLoad()
        onOffRecordiButton(recording: false)
    }
    //MARK: - Record Audio Function
    @IBAction func recordAudio(_ sender: UIButton) {
        onOffRecordiButton(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
   }
   //MARK: - Stop Recording Function
   @IBAction func stopRecording(_ sender: UIButton) {
        onOffRecordiButton(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
   }
    //MARK: - Finished Recording Function
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    //MARK: - Perform Segue to the next screen PlayViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    //MARK: - On/Off Record/Stop Button
    func onOffRecordiButton(recording: Bool) {
        recordingLabel.text = recording ? "Recording in progress" : "Tap to Record"
        recordButton.isEnabled = recording ? false : true
        stopRecordingButton.isEnabled = !recordButton.isEnabled
    }
}
