//
//  FanFanViewController.swift
//  WJFanFanGameDemo
//
//  Created by jh navi on 15/9/22.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

import UIKit
import AVFoundation

class FanFanViewController: UIViewController {
    
    @IBOutlet weak var birdView: UIImageView!
    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var congratulationView: UIImageView!
    
    
    var bgPlayer: AVAudioPlayer!//背景音乐
    var clickPlayer :AVAudioPlayer!//点击音效
    var doublePlayer : AVAudioPlayer!//成对儿音效
    var timer : NSTimer!//定时器
    var doubleCount :Int = 0//匹配对数
    var isGameOver :Bool = false//游戏结束
    var tempImageView :MyImageView!// 临时对象,记录第一次点击的水果

    
    @IBAction func doMusic(sender: AnyObject) {
        //音乐开关
        if (self.bgPlayer.playing)
        {
            self.bgPlayer.stop()
            sender.setBackgroundImage(UIImage(named: "soundClose"), forState: UIControlState.Normal)
        }
        else
        {
            self.bgPlayer.play()
            sender.setBackgroundImage(UIImage(named: "soundOpen"), forState: UIControlState.Normal)
        }

    }
    @IBAction func doRefresh(sender: AnyObject?) {
        self.bgPlayer.play()
        self.timeCountLabel.text = "60"
        self.doubleCount = 0
        self.birdView.startAnimating()
        self.tempImageView = nil
        
        if (isGameOver || timer == nil) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount", userInfo: nil, repeats: true)
            self.birdView.startAnimating()
            self.isGameOver = false
        }
        
        self.loadFruits()
        self.turnAll2Left()
        self.congratulationView.hidden = true
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(),{
            self.turnAll2Right()
        })

    }
    
    func prepareMusic() {
        self.bgPlayer = loadMusicByName("bg")
        self.clickPlayer = loadMusicByName("click")
        self.doublePlayer = loadMusicByName("double")
        self.bgPlayer.prepareToPlay()
        self.clickPlayer.prepareToPlay()
        self.doublePlayer.prepareToPlay()
        self.bgPlayer.volume = 0.8
        self.clickPlayer.volume = 0.8
        self.doublePlayer.volume = 0.8
    }
    func loadMusicByName(name: String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource(name,ofType: "mp3")
        let url = NSURL(fileURLWithPath: path!)
        NSLog("url = %@", url!)
        var player = AVAudioPlayer(contentsOfURL: url,error: nil)
        NSLog("player = %@", player)
        player.prepareToPlay()
        player.volume = 0.9
        return player
    }
    
    func prepareTimeCount() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeCount", userInfo: nil, repeats: true)
    }
    
    func timeCount() {
        var timeCount: Int = self.timeCountLabel.text!.toInt()!
        if timeCount <= 0 {
            self.timer.invalidate()
            self.gameOver()
        }else {
            timeCount--
        }
        self.timeCountLabel.text = String(timeCount)
    }
    
    func gameOver() {
        self.isGameOver = true
        self.birdView.startAnimating()
        self.timer.invalidate()
    }
    
    func gameWin()
    {
        self.isGameOver = true
        self.birdView!.stopAnimating()
        self.congratulationView!.hidden = false
        self.timer.invalidate()
    }
    
    func prepareBird() {
        var images: NSMutableArray = NSMutableArray()
        for i in 1...7 {
            var str = "bird\(i).png"
            var image = UIImage(named: str)
            images.addObject(image!)
        }
        self.birdView.animationImages = images as [AnyObject]
        self.birdView.animationDuration = 1.2
    }
    
    func prepareWinView() {
        var images: NSMutableArray! = NSMutableArray()
        for i in 1...12 {
            var image = UIImage(named: "congratulation\(i).png")
            images.addObject(image!)
        }
        self.congratulationView.animationImages = images as [AnyObject]
        self.congratulationView.animationDuration = 3
        self.congratulationView.startAnimating()
        self.view.addSubview(self.congratulationView)
    }
    
    func loadFruits() {
        var tags = randomTags()
        var images = randomImages()
        var index = 0
        for i in 0...9
        {
            //取出一张图片
            var image: UIImage = images[i] as! UIImage
            //获取两个问号
            var my1: MyImageView = self.view.viewWithTag(tags[index] as! Int) as! MyImageView
            index++
            var my2: MyImageView = self.view.viewWithTag(tags[index] as! Int) as! MyImageView
            index++
            
            //设置相同的图片和标记
            my1.myImage = image
            my2.myImage = image
            my1.myTag = i
            my2.myTag = i
            
        }
    }
    
    func randomTags() -> NSArray {
        var mArr: NSMutableArray = NSMutableArray()
        var count = 0
        while(mArr.count < 20) {
            var tag = arc4random()%20 + 100
            var t = NSNumber(unsignedInt: tag)
            if(!mArr.containsObject(t)) {
                mArr.addObject(t)
            }
        }
        return mArr
    }
    
    func randomImages() -> NSArray {
        var images: NSMutableArray = NSMutableArray()
        while(images.count < 10) {
            var i = arc4random()%18 + 1
            var image: UIImage = UIImage(named: "fruit\(i).png")!
            if(!images.containsObject(image)) {
                images.addObject(image)
            }
        }
        return images
    }
    
    func turnAll2Left() {
        for i in 100...119 {
            var myI = self.view.viewWithTag(i) as! MyImageView
            myI.turn2Left()
        }
    }
    
    func turnAll2Right() {
        for i in 100...119 {
            var myI = self.view.viewWithTag(i) as! MyImageView
            myI.turn2Right()
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.prepareMusic()
        self.prepareTimeCount()
        self.prepareBird()
        self.prepareWinView()
        self.doRefresh(nil)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        var touch :UITouch =  touches.first as! UITouch
        if(touch.view.isKindOfClass(MyImageView.self))
        {
            var currentTouchView = touch.view as! MyImageView
            currentTouchView.turn2Left()
            self.clickPlayer.play()
            if (self.tempImageView == nil)
            {
                self.tempImageView = currentTouchView
            }
            else
            {
                if(currentTouchView.myTag == self.tempImageView.myTag)
                {
                    self.doublePlayer.play()
                    self.tempImageView = nil
                    self.doubleCount++
                    if(self.doubleCount == 10)
                    {
                        self.gameWin()
                    }
                }
                else
                {
                    self.tempImageView.turn2Right()
                    self.tempImageView = currentTouchView
                }
            }
        }
    }


}
