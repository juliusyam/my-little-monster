//
//  ViewController.swift
//  my-little-monster
//
//  Created by Julius on 04/09/2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2 //All Cap is for constant
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALITIES = 3
    
    var penalties = 0
    var timer: Timer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemDroppedOnCharacter), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
        
        let musicPlayerURL = Bundle.main.path(forResource: "cave-music", ofType: "mp3")
        let sfxBiteURL = Bundle.main.path(forResource: "bite", ofType: "wav")
        let sfxHeartURL = Bundle.main.path(forResource: "heart", ofType: "wav")
        let sfxDeathURL = Bundle.main.path(forResource: "death", ofType: "wav")
        let sfxSkullURL = Bundle.main.path(forResource: "skull", ofType: "wav")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicPlayerURL!))
            sfxBite = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sfxBiteURL!))
            sfxHeart = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sfxHeartURL!))
            sfxDeath = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sfxDeathURL!))
            sfxSkull = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sfxSkullURL!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }
    
    @objc func itemDroppedOnCharacter(notif: AnyObject) {
        print("ITEM DROPPED ON CHARACTER")
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.isUserInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        foodImg.isUserInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        }
        else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(changeGameState), userInfo: nil, repeats: true)
    }
    
    @objc func changeGameState() {
        
        if monsterHappy == false {
            penalties+=1
            sfxSkull.play()
        }
        
        if penalties == 1 {
            penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = DIM_ALPHA
        }
        else if penalties == 2 {
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = DIM_ALPHA
        }
        else if penalties >= 3 {
            penalty3Img.alpha = OPAQUE
        }
        else {
            penalty1Img.alpha = DIM_ALPHA
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
        }
        
        if penalties >= MAX_PENALITIES {
            gameOver()
        }
        
        let rand = arc4random_uniform(2) //Give random value of 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.isUserInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.isUserInteractionEnabled = true
        }
        else {
            heartImg.alpha = DIM_ALPHA
            heartImg.isUserInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.isUserInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
}

