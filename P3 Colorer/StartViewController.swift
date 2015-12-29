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
        
        //set background image
        let backgroundImage = UIImage(named: "background")
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.insertSubview(backgroundImageView, atIndex: 0)
        
        //create Create button
        let createButton = UIButton()
        createButton.frame = CGRectMake(0, 0, view.bounds.width/3, view.bounds.width/3)
        createButton.setBackgroundImage(UIImage(named: "createIcon"), forState: .Normal)
        createButton.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        createButton.addTarget(self, action: "createNew:", forControlEvents: .TouchUpInside)
        self.view.addSubview(createButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func createNew(sender: UIButton){
        let shapeVC = DrawViewController()
        shapeVC.selected = "random"
        shapeVC.shape = "rectangle"
        shapeVC.barButtonColor = UIColor(red:0.21, green:0.22, blue:0.22, alpha:1.0) //dark grey
        shapeVC.shapeColor = shapeVC.barButtonColor
        shapeVC.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.pushViewController(shapeVC, animated: true)
        
    }
    
    func randomButtonPressed(sender: UIButton!){
        let randomVC = RandomBackgroundViewController()
        self.navigationController?.pushViewController(randomVC, animated: true)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
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
