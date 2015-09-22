//
//  ViewController.swift
//  WJFanFanGameDemo
//
//  Created by jh navi on 15/9/22.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func startGame(sender: AnyObject) {
        self.performSegueWithIdentifier("game_segue", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

