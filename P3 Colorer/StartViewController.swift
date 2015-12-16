//
//  StartViewController.swift
//  P3 Colorer
//
//  Created by Monica Ong on 12/15/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //create Random button
        let randomButton = UIButton()
        randomButton.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height/4)
        randomButton.setTitle("RANDOM", forState: .Normal)
        randomButton.setTitleColor(UIColor(red:0.21, green:0.22, blue:0.22, alpha:1.0), forState: .Normal)
        randomButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        randomButton.setBackgroundImage(UIImage(named: "Random"), forState: .Normal)
        randomButton.addTarget(self, action: "randomButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(randomButton)
        
        //create Blue button
        let blueButton = UIButton()
        blueButton.frame = CGRectMake(0, view.bounds.height/4, view.bounds.width, view.bounds.height/4)
        blueButton.setTitle("BLUE", forState: .Normal)
        blueButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        blueButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        blueButton.setBackgroundImage(UIImage(named: "Blue"), forState: .Normal)
        blueButton.addTarget(self, action: "blueButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(blueButton)
        
        //create Triangle button
        let triangleButton = UIButton()
        triangleButton.frame = CGRectMake(0, view.bounds.height/2, view.bounds.width, view.bounds.height/4)
        triangleButton.setTitle("TRIANGLE", forState: .Normal)
        triangleButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        triangleButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        triangleButton.setBackgroundImage(UIImage(named: "Triangle"), forState: .Normal)
        triangleButton.addTarget(self, action: "triangleButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(triangleButton)
        
        //create Red button
        let redButton = UIButton()
        redButton.frame = CGRectMake(0, view.bounds.height*3/4, view.bounds.width, view.bounds.height/4)
        redButton.setTitle("RED", forState: .Normal)
        redButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        redButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        redButton.setBackgroundImage(UIImage(named: "Red"), forState: .Normal)
        redButton.addTarget(self, action: "redButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(redButton)
        
    }
    
    func randomButtonPressed(sender: UIButton!){
    
    }
    
    func blueButtonPressed(sender: UIButton!){
        
    }
    
    func triangleButtonPressed(sender: UIButton!){
        
    }
    
    func redButtonPressed(sender: UIButton!){
        
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
