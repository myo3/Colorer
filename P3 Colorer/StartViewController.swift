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

    func createNew(sender: UIButton){
        let shapeVC = DrawViewController()
        shapeVC.selected = "random"
        shapeVC.shapeType = "rectangle"
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
