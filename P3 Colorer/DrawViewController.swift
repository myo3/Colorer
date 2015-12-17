//
//  DrawViewController.swift
//  P3 Colorer
//
//  Created by Monica Ong on 12/15/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    var selected: String?
    var shape: String?
    var color: UIColor?
    var height: Int = 60
    var width: Int = 60
    var rectangles: Set<UIView> = Set<UIView>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create bar buttons
        let deleteBarButton = UIBarButtonItem(image: UIImage(named: "greyDelete"), style: .Plain, target: self, action: "deleteView:")
        deleteBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let eraseBarButton = UIBarButtonItem(image: UIImage(named: "greyErase"), style: .Plain, target: self, action: "erase:")
        eraseBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let resizeBarButton = UIBarButtonItem(image: UIImage(named: "greyResize"), style: .Plain, target: self, action: "resize:")
        resizeBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let viewBarButton = UIBarButtonItem(image: UIImage(named: "greyView"), style: .Plain, target: self, action: "view:")
        viewBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let colorBarButton = UIBarButtonItem(image: UIImage(named: "greyColor"), style: .Plain, target: self, action: "color:")
        colorBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let drawBarButton = UIBarButtonItem(image: UIImage(named: "greyDraw"), style: .Plain, target: self, action: "draw:")
        drawBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            .FlexibleSpace, target: self, action: nil)
        flexibleSpace.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        
        //set up toolbar
        let toolbarItems = [drawBarButton, flexibleSpace, eraseBarButton, flexibleSpace, colorBarButton, flexibleSpace, resizeBarButton, flexibleSpace, viewBarButton, flexibleSpace, deleteBarButton]
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.frame = CGRectMake(0, view.bounds.height-toolbar.bounds.height, toolbar.bounds.width, toolbar.bounds.height)
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(patternImage: UIImage(named: "\(selected!)Toolbar")!)
        toolbar.setItems(toolbarItems, animated: true)
        self.view.addSubview(toolbar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func deleteView(sender: UIBarButtonItem) {
        
    }
    
    func erase(sender: UIBarButtonItem){
        
    }
    
    func resize(sender: UIBarButtonItem){
        
    }
    
    func view(sender: UIBarButtonItem){
        
    }
    
    func color(sender: UIBarButtonItem){
        
    }
    
    func draw(sender: UIBarButtonItem){
        
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
