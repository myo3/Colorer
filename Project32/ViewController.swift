//
//  ViewController.swift
//  Project3
//
//  Created by Monica Ong on 10/6/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "randomColorSegue"{
            if let shapeViewController = segue.destinationViewController as? ShapeViewController {
                shapeViewController.color = nil
                shapeViewController.alphaValue = 1.0
            }
        }
        if segue.identifier == "redSegue" {
            if let shapeViewController = segue.destinationViewController as? ShapeViewController {
                shapeViewController.color = UIColor(red: 0.82, green: 0.05, blue: 0.05, alpha: 1.0)
                shapeViewController.redValue = 0.82
                shapeViewController.greenValue = 0.05
                shapeViewController.blueValue = 0.05
                shapeViewController.alphaValue = 1.0
            }
        }
        if segue.identifier == "blueSegue" {
            if let shapeViewController = segue.destinationViewController as? ShapeViewController {
                shapeViewController.color = UIColor(red: 0.33, green: 0.89, blue: 0.96, alpha: 1)
                shapeViewController.redValue = 0.33
                shapeViewController.greenValue = 0.89
                shapeViewController.blueValue = 0.96
                shapeViewController.alphaValue = 1.0
            }
        }
        if segue.identifier == "triangleSegue"{
            if let shapeViewController = segue.destinationViewController as? ShapeViewController {
                shapeViewController.shape = "Triangle"
                shapeViewController.color = UIColor(red: 0.08, green: 0.61, blue: 0.08, alpha: 1.0)
                shapeViewController.redValue = 0.08
                shapeViewController.greenValue = 0.61
                shapeViewController.blueValue = 0.08
                shapeViewController.alphaValue = 1.0
            }
            
        }
    }
}
