//
//  JobImageViewController.swift
//  Works
//
//  Created by Heesu Yun on 4/24/20.
//  Copyright © 2020 Heesu Yun. All rights reserved.
//

import UIKit
import AVFoundation

class JobImageViewController: UIViewController {

    @IBOutlet weak var jobImageview: UIImageView!
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            playSound(name: "type")
            

        }
        func playSound(name: String){
            if let sound = NSDataAsset(name: name){
                do{
                    try audioPlayer = AVAudioPlayer(data: sound.data)
                    audioPlayer.play()
                }catch{
                    print("ERROR: data in \(name) coudln't be played as a sound.")
                }
                }else{
                    print("ERROR: file\(name) didn't load")
                }
        }
        
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        performSegue(withIdentifier: "ShowTableView", sender: nil)
    }
    
    }


