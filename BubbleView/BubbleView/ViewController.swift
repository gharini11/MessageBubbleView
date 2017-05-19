//
//  ViewController.swift
//  BubbleView
//
//  Created by Harini Reddy on 11/19/16.
//  Copyright © 2016 harini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var chatBubbleView : BubbleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization of chat bubble
        chatBubbleView = BubbleView(frame: CGRectMake(50.0, 50.0, 100.0, 70.0))
        chatBubbleView?.strokeColor = UIColor.grayColor()
        chatBubbleView?.fillColor = UIColor.cyanColor()
        chatBubbleView?.isRightBubble = false
        self.view.addSubview(chatBubbleView!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

