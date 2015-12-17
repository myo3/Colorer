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
    var barButtonColor: UIColor?
    var eraseBarButton = UIBarButtonItem()
    var viewBarButton = UIBarButtonItem()
    
    var canvas: UIView = UIView()
    var shape: String?
    var shapeColor: UIColor?
    var height: Int = 60
    var width: Int = 60
    var rectangles: Set<UIView> = Set<UIView>()
    var shapeView: UIView = UIView()
    
    var eraseMode: Bool = false
    var visible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create bar buttons
        let backBarButton = UIBarButtonItem(image: UIImage(named: "blackBack"), style: .Plain, target: self, action: "returnHome:")
        backBarButton.tintColor = barButtonColor
        let deleteBarButton = UIBarButtonItem(image: UIImage(named: "greyDelete"), style: .Plain, target: self, action: "deleteView:")
        deleteBarButton.tintColor = barButtonColor
        eraseBarButton = UIBarButtonItem(image: UIImage(named: "greyErase"), style: .Plain, target: self, action: "erase:")
        eraseBarButton.tintColor = barButtonColor
        let resizeBarButton = UIBarButtonItem(image: UIImage(named: "greyResize"), style: .Plain, target: self, action: "resize:")
        resizeBarButton.tintColor = barButtonColor
        viewBarButton = UIBarButtonItem(image: UIImage(named: "greyView"), style: .Plain, target: self, action: "view:")
        viewBarButton.tintColor = barButtonColor
        let colorBarButton = UIBarButtonItem(image: UIImage(named: "greyColor"), style: .Plain, target: self, action: "color:")
        colorBarButton.tintColor = barButtonColor
        let drawBarButton = UIBarButtonItem(image: UIImage(named: "greyDraw"), style: .Plain, target: self, action: "draw:")
        drawBarButton.tintColor = barButtonColor
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            .FlexibleSpace, target: self, action: nil)
        
        //set up toolbar
        let toolbarItems = [backBarButton, flexibleSpace, drawBarButton, flexibleSpace, eraseBarButton, flexibleSpace, colorBarButton, flexibleSpace, resizeBarButton, flexibleSpace, viewBarButton, flexibleSpace, deleteBarButton]
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.frame = CGRectMake(0, view.bounds.height-toolbar.bounds.height, toolbar.bounds.width, toolbar.bounds.height)
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(patternImage: UIImage(named: "\(selected!)Toolbar")!)
        toolbar.setItems(toolbarItems, animated: true)
        self.view.addSubview(toolbar)
        
        //set up canvas
        canvas = UIView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height-toolbar.bounds.height))
        canvas.backgroundColor = UIColor.whiteColor()
        self.view.insertSubview(canvas, belowSubview: toolbar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if eraseMode{ //eraseMode on
            if let touch: UITouch! = touches.first!{
                if rectangles.contains(touch.view!) {
                    rectangles.remove(touch.view!)
                    touch.view?.removeFromSuperview()
                }
            }
        } else if !eraseMode && visible{ //eraseMode off
            let location = touches.first!.locationInView(view)
            //create shape
            if shape == "triangle"{
                shapeView = TriangleView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                
            }
            else if shape == "rectangle"{
                shapeView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.layer.cornerRadius = 10
            }
            //place shape where user touched
            shapeView.center = location
            //set shape color
            shapeView.backgroundColor = shapeColor
            //add shape to view
            canvas.addSubview(shapeView)
            //add shape to rectangles array
            rectangles.insert(shapeView)
        }
    }
    
    func deleteView(sender: UIBarButtonItem) {
        for rect in rectangles{
            rect.removeFromSuperview()
        }
        rectangles.removeAll()
    }
    
    func erase(sender: UIBarButtonItem){
        eraseMode = !eraseMode
        
        if eraseMode{ //eraseMode on
            eraseBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }else{ //eraseMode off
            eraseBarButton.tintColor = barButtonColor
        }
    }
    
    func resize(sender: UIBarButtonItem){
        
    }
    
    func view(sender: UIBarButtonItem){
        visible = !visible
        
        if visible{
            for rect in rectangles{
                rect.alpha = 1
            }
            viewBarButton.tintColor = barButtonColor
        }else{
            for rect in rectangles{
                rect.alpha = 0
            }
            viewBarButton.tintColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        }
    }
    
    func color(sender: UIBarButtonItem){
        
    }
    
    func draw(sender: UIBarButtonItem){
        
    }
    
    func returnHome(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
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
