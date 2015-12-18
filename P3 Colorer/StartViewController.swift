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
        
        //create Random button
        let randomButton = UIButton()
        randomButton.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height/4)
        randomButton.setTitle("RANDOM", forState: .Normal)
        randomButton.setTitleColor(UIColor(red:0.21, green:0.22, blue:0.22, alpha:1.0), forState: .Normal)
        randomButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        randomButton.setBackgroundImage(UIImage(named: "random"), forState: .Normal)
        randomButton.addTarget(self, action: "randomButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(randomButton)
        
        //create Blue button
        let blueButton = UIButton()
        blueButton.tag = 1
        blueButton.frame = CGRectMake(0, view.bounds.height/4, view.bounds.width, view.bounds.height/4)
        blueButton.setTitle("BLUE", forState: .Normal)
        blueButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        blueButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        blueButton.setBackgroundImage(UIImage(named: "blue"), forState: .Normal)
        blueButton.addTarget(self, action: "shapeButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(blueButton)
        
        //create Triangle button
        let triangleButton = UIButton()
        triangleButton.tag = 2
        triangleButton.frame = CGRectMake(0, view.bounds.height/2, view.bounds.width, view.bounds.height/4)
        triangleButton.setTitle("TRIANGLE", forState: .Normal)
        triangleButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        triangleButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        triangleButton.setBackgroundImage(UIImage(named: "triangle"), forState: .Normal)
        triangleButton.addTarget(self, action: "shapeButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(triangleButton)
        
        //create Red button
        let redButton = UIButton()
        redButton.tag = 3
        redButton.frame = CGRectMake(0, view.bounds.height*3/4, view.bounds.width, view.bounds.height/4)
        redButton.setTitle("RED", forState: .Normal)
        redButton.setTitleColor(UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0), forState: .Normal)
        redButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 50)
        redButton.setBackgroundImage(UIImage(named: "red"), forState: .Normal)
        redButton.addTarget(self, action: "shapeButtonPressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(redButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func randomButtonPressed(sender: UIButton!){
        let randomVC = RandomBackgroundViewController()
        self.navigationController?.pushViewController(randomVC, animated: true)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func shapeButtonPressed(sender: UIButton!){
        let shapeVC = DrawViewController()
        let button = sender as UIButton
        switch button.tag{
        case 1: //blue rectangle
            shapeVC.selected = "blue"
            shapeVC.shape = "rectangle"
            shapeVC.barButtonColor = UIColor(red:0.03, green:0.25, blue:0.51, alpha:1.0)
            shapeVC.shapeColor = shapeVC.barButtonColor //UIColor(red:0.17, green:0.55, blue:0.75, alpha:1.0)
        case 2: //triangle
            shapeVC.selected = "triangle"
            shapeVC.shape = "triangle"
            shapeVC.barButtonColor = UIColor(red:0.00, green:0.27, blue:0.16, alpha:1.0)
            shapeVC.shapeColor = shapeVC.barButtonColor //UIColor(red:0.14, green:0.52, blue:0.26, alpha:1.0)
        case 3: //red rectangle
            shapeVC.selected = "red"
            shapeVC.shape = "rectangle"
            shapeVC.barButtonColor = UIColor(red:0.50, green:0.00, blue:0.15, alpha:1.0)
            shapeVC.shapeColor = shapeVC.barButtonColor //UIColor(red:0.74, green:0.00, blue:0.15, alpha:1.0)
        default://default is blue rectangle
            shapeVC.selected = "blue"
            shapeVC.shape = "rectangle"
            shapeVC.barButtonColor = UIColor(red:0.03, green:0.25, blue:0.51, alpha:1.0)
            shapeVC.shapeColor = shapeVC.barButtonColor //UIColor(red:0.17, green:0.55, blue:0.75, alpha:1.0)
        }
        shapeVC.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationController?.pushViewController(shapeVC, animated: true)
        
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
