//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by msuzuki on 2/20/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    // MARK: - Buttons Variables
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    // MARK: - Audio Variables
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    //MARK: - Initial Screen Loader
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    //MARK: - Enable Play Button
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    //MARK: - Sodund Swtich/Case Condition
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    //MARK: - Stop Playing Audio
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
}
