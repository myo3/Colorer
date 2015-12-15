//
//  RandomBackgroundViewController.swift
//  Project3
//
//  Created by Monica Ong on 10/7/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class RandomBackgroundViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInView(view)
        let rbackView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        rbackView.center = location
        rbackView.backgroundColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UINT32_MAX), green: CGFloat(arc4random()) / CGFloat(UINT32_MAX), blue: CGFloat(arc4random()) / CGFloat(UINT32_MAX), alpha: 1)
        rbackView.layer.cornerRadius = 10
        view.addSubview(rbackView)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
