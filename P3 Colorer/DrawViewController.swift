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
    
    var canvas: UIView = UIView()
    var shape: String?
    var shapeColor: UIColor?
    var fontColor: UIColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    var height: Int = 60
    var width: Int = 60
    var rectangles: Set<UIView> = Set<UIView>()
    var shapeView: UIView = UIView()
    
    var toolbar: UIToolbar = UIToolbar()
    var barButtonColor: UIColor?
    var eraseBarButton = UIBarButtonItem()
    var viewBarButton = UIBarButtonItem()
    var resizeBarButton = UIBarButtonItem()
    var colorBarButton = UIBarButtonItem()
    var drawBarButton = UIBarButtonItem()
    
    var drawMode: Bool = false
    var eraseMode: Bool = false
    var colorMode: Bool = false
    var resizeMode: Bool = false
    var visible: Bool = true
    
    var sizeToolbar: UIView = UIView()
    var heightSlider: UISlider = UISlider()
    var squareSlider: UISlider = UISlider()
    var widthSlider: UISlider = UISlider()
    var heightValueLabel: UILabel = UILabel()
    var squareValueLabel: UILabel = UILabel()
    var widthValueLabel: UILabel = UILabel()
    
    var colorSlider: ColorSlider = ColorSlider()
    
    var selectedShape: UIView?
    var corners: [UIImageView] = [UIImageView]()
    // Symbols       Indexes
    //o---^---o     0---5---2
    //<---*--->     1---8---3
    //o---v---o     6---7---4
    
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
        resizeBarButton = UIBarButtonItem(image: UIImage(named: "greyResize"), style: .Plain, target: self, action: "resize:")
        resizeBarButton.tintColor = barButtonColor
        viewBarButton = UIBarButtonItem(image: UIImage(named: "greyView"), style: .Plain, target: self, action: "view:")
        viewBarButton.tintColor = barButtonColor
        colorBarButton = UIBarButtonItem(image: UIImage(named: "greyColor"), style: .Plain, target: self, action: "color:")
        colorBarButton.tintColor = shapeColor
        drawBarButton = UIBarButtonItem(image: UIImage(named: "greyDraw"), style: .Plain, target: self, action: "draw:")
        drawBarButton.tintColor = barButtonColor
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            .FlexibleSpace, target: self, action: nil)
        
        //set up toolbar
        let toolbarItems = [backBarButton, flexibleSpace, drawBarButton, flexibleSpace, eraseBarButton, flexibleSpace, colorBarButton, flexibleSpace, resizeBarButton, flexibleSpace, viewBarButton, flexibleSpace, deleteBarButton]
        toolbar.sizeToFit()
        toolbar.frame = CGRectMake(0, view.bounds.height-toolbar.bounds.height, toolbar.bounds.height, toolbar.bounds.height)
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(patternImage: UIImage(named: "\(selected!)Toolbar")!)
        //toolbar.layer.contents = UIImage(named: "\(selected!)Toolbar")!.CGImage //soft gradient color toolbar
        toolbar.clipsToBounds = true //get rid of top line
        toolbar.setItems(toolbarItems, animated: true)
        self.view.addSubview(toolbar)
        
        //set up canvas
        canvas = UIView(frame: CGRectMake(0, 0, view.bounds.height, view.bounds.height-toolbar.bounds.height))
        self.view.insertSubview(canvas, belowSubview: toolbar)
        
        //set up size toolbar
        sizeToolbar = UIView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, view.bounds.height/6))
        sizeToolbar.layer.contents = UIImage(named: "\(selected!)SizeToolbar")!.CGImage
        //sizeToolbar.backgroundColor = UIColor(patternImage: UIImage(named: "\(selected!)SizeToolbar")!) //looks literally the same w/ this
        self.view.addSubview(sizeToolbar)
        
        //set up slider labels
        let sliderSpace = CGFloat(10)
        let sliderCenterY = sizeToolbar.bounds.height/6
        let labelWidth = CGFloat(80)
        let labelHeight = CGFloat(21)
        let valueLabelWidth = CGFloat(43)

        let heightLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        let squareLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        let widthLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        heightLabel.center.y = sliderCenterY
        squareLabel.center.y = sliderCenterY*3
        widthLabel.center.y = sliderCenterY*5
        heightLabel.textAlignment = NSTextAlignment.Right
        squareLabel.textAlignment = NSTextAlignment.Right
        widthLabel.textAlignment = NSTextAlignment.Right
        heightLabel.textColor = barButtonColor
        squareLabel.textColor = barButtonColor
        widthLabel.textColor = barButtonColor
        heightLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        squareLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightLabel.text = "HEIGHT"
        squareLabel.text = "SQUARE"
        widthLabel.text = "WIDTH"
        sizeToolbar.addSubview(heightLabel)
        sizeToolbar.addSubview(squareLabel)
        sizeToolbar.addSubview(widthLabel)
        
        //set up sliders
        let sliderWidth = sizeToolbar.bounds.width - (2*sliderSpace) - labelWidth - (2*sliderSpace) - valueLabelWidth
        heightSlider = UISlider(frame: CGRectMake(heightLabel.frame.maxX + sliderSpace, 0, sliderWidth, 31))
        squareSlider = UISlider(frame: CGRectMake(squareLabel.frame.maxX + sliderSpace, 0, sliderWidth, 31))
        widthSlider = UISlider(frame: CGRectMake(widthLabel.frame.maxX + sliderSpace, 0, sliderWidth, 31))
        heightSlider.maximumValue = 100
        squareSlider.maximumValue = 100
        widthSlider.maximumValue = 100
        heightSlider.value = Float(height)
        squareSlider.value = Float(width)
        widthSlider.value = Float(width)
        heightSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        squareSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        widthSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        heightSlider.tag = 1
        squareSlider.tag = 2
        widthSlider.tag = 3
        heightSlider.center.y = heightLabel.center.y
        squareSlider.center.y = squareLabel.center.y
        widthSlider.center.y = widthLabel.center.y
        heightSlider.minimumTrackTintColor = barButtonColor
        squareSlider.minimumTrackTintColor = barButtonColor
        widthSlider.minimumTrackTintColor = barButtonColor
        heightSlider.maximumTrackTintColor = fontColor
        squareSlider.maximumTrackTintColor = fontColor
        widthSlider.maximumTrackTintColor = fontColor
        heightSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbHeight")!, forState: .Normal)
        squareSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbSquare")!, forState: .Normal)
        widthSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbWidth")!, forState: .Normal)
        //        widthSlider.convertPoint(widthSlider.center, toView: sizeToolbar) //see if this is actually necessary
        sizeToolbar.addSubview(heightSlider)
        sizeToolbar.addSubview(squareSlider)
        sizeToolbar.addSubview(widthSlider)
        
        //set up slider value labels
        heightValueLabel = UILabel(frame: CGRectMake(heightSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        squareValueLabel = UILabel(frame: CGRectMake(squareSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        widthValueLabel = UILabel(frame: CGRectMake(widthSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        heightValueLabel.center.y = heightLabel.center.y
        squareValueLabel.center.y = squareLabel.center.y
        widthValueLabel.center.y = widthLabel.center.y
        heightValueLabel.textAlignment = NSTextAlignment.Left
        squareValueLabel.textAlignment = NSTextAlignment.Left
        widthValueLabel.textAlignment = NSTextAlignment.Left
        heightValueLabel.textColor = barButtonColor
        squareValueLabel.textColor = barButtonColor
        widthValueLabel.textColor = barButtonColor
        heightValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        squareValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightValueLabel.text = "\(height)"
        squareValueLabel.text = "\(width)"
        widthValueLabel.text = "\(width)"
        sizeToolbar.addSubview(heightValueLabel)
        sizeToolbar.addSubview(squareValueLabel)
        sizeToolbar.addSubview(widthValueLabel)
        
        //set up color toolbar
        colorSlider = ColorSlider(frame: CGRectMake(view.bounds.width, 30, view.bounds.width/16, view.bounds.height/4))
//        colorSlider.previewEnabled = true
        colorSlider.borderColor = barButtonColor!
        colorSlider.addTarget(self, action: "willChangeColor:", forControlEvents: .TouchDown)
        colorSlider.addTarget(self, action: "isChangingColor:", forControlEvents: .ValueChanged)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpOutside)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpInside)
        self.view.insertSubview(colorSlider, aboveSubview: canvas)
        
        //set up corners: set color, add pan feature, count = 9
        for i in 0...8 {
            let corner = UIImageView(frame: CGRectMake(0, 0, 10, 10))
            corner.backgroundColor = fontColor
            corners.append(corner)
            corner.tag = i
            corner.userInteractionEnabled = true
            let pan = UIPanGestureRecognizer(target: self, action: "moveShape:")
            corner.addGestureRecognizer(pan)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !eraseMode && visible && drawMode{ //eraseMode off, visbility on, draw on
            let location = touches.first!.locationInView(view)
            //create shape
            if shape == "triangle"{
                shapeView = TriangleView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                
            }
            else if shape == "rectangle"{
                shapeView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.layer.cornerRadius = 10 //CGFloat(width)/2.0 //circle
            }
            //place shape where user touched
            shapeView.center = location
            //set shape color
            shapeView.backgroundColor = shapeColor
            //add gesture recognizers
            let tap = UITapGestureRecognizer(target: self, action: "tapShape:")
//            let pan = UIPanGestureRecognizer(target: self, action: "moveShape:")
            let rotation = UIRotationGestureRecognizer(target: self, action: "rotateShape:")
            //let pinch = UIPinchGestureRecognizer(target: self, action: "scaleShape:")
            shapeView.addGestureRecognizer(tap)
//            shapeView.addGestureRecognizer(pan)
            shapeView.addGestureRecognizer(rotation)
//            shapeView.addGestureRecognizer(pinch)
            //add shape to view
            if !CGRectIntersectsRect(shapeView.frame, sizeToolbar.frame){
                canvas.addSubview(shapeView)
                //add shape to rectangles array
                rectangles.insert(shapeView)
            }
        }
    }
    
    //Shape functions
    func tapShape(sender: UITapGestureRecognizer){
        selectedShape = sender.view!
        
        if resizeMode{
            //place each corner in view
            for corner in corners {
                self.view.insertSubview(corner, aboveSubview: selectedShape!)
            }
            
            //place each corner in proper place
            corners = placeCorners(corners, selectedShape: selectedShape!)
        }
        
        if eraseMode{
            if rectangles.contains(selectedShape!) {
                rectangles.remove(selectedShape!)
                selectedShape!.removeFromSuperview()
            }
        }
    }
    
    func moveShape(sender: UIPanGestureRecognizer){
        let corner = sender.view as! UIImageView
        
        //resize shape
        let trans = sender.translationInView(canvas)
        switch corner.tag{
        case 0: //works, combine 1 & 5
            corner.center.x = corner.center.x + trans.x
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.center.x = shape.center.x + trans.x
                shape.frame.size.height = shape.frame.height - trans.y
                shape.center.y = shape.center.y + trans.y
            }
        case 1: //works
            corner.center.x = corner.center.x + trans.x
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.center.x = shape.center.x + trans.x
            }
        case 2: //works, combine 5 & 3
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            if let shape = selectedShape{
                shape.frame.size = CGSize(width: shape.frame.width + trans.x , height: shape.frame.height - trans.y)
                shape.center.y = shape.center.y + trans.y
            }
        case 3: //works
            corner.center.x = corner.center.x + trans.x
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width + trans.x
            }
        case 4: //works
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            if let shape = selectedShape{
                shape.frame.size = CGSize(width: shape.frame.width + trans.x , height: shape.frame.height + trans.y)
            }
        case 5: //works
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.height = shape.frame.height - trans.y
                shape.center.y = shape.center.y + trans.y
            }
        case 6: //works, combine 1 & 7
            corner.center.x = corner.center.x + trans.x
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.frame.size.height = shape.frame.height + trans.y
                shape.center.x = shape.center.x + trans.x
            }
        case 7: //works
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.height = shape.frame.height + trans.y
            }
        case 8: //works
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            selectedShape?.center = CGPoint(x: (selectedShape?.center.x)! + trans.x, y: (selectedShape?.center.y)! + trans.y)
        default:
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            print("default called")
        }
        
        sender.setTranslation(CGPointZero, inView: canvas)
        
        //hide corners while changing size
        if (sender.state == UIGestureRecognizerState.Began || sender.state == UIGestureRecognizerState.Changed){
            for c in corners{
                //set panned corner to panIcon
                if c.tag == corner.tag{
                    corner.backgroundColor = UIColor.clearColor()
                    corner.image = UIImage(named: "panIcon")
                    corner.contentMode = UIViewContentMode.ScaleAspectFit
                    continue
                }
                c.hidden = true
            }
        }
        //unhide corners when finish changing size
        if(sender.state == UIGestureRecognizerState.Ended || sender.state == UIGestureRecognizerState.Failed || sender.state == UIGestureRecognizerState.Cancelled){
            for c in corners{
                //set panned corner back to grey square
                if c.tag == corner.tag{
                    corner.backgroundColor = fontColor
                    corner.image = nil
                    continue
                }
                c.hidden = false
            }
            if let shape = selectedShape{
                corners = placeCorners(corners, selectedShape: shape)
            }
        }
    }
    
    func rotateShape(sender: UIRotationGestureRecognizer){
        let shapeView = sender.view!
        let rotation = sender.rotation
        shapeView.transform = CGAffineTransformRotate(shapeView.transform, rotation)
        sender.rotation = 0
    }
    
    func scaleShape(sender: UIPinchGestureRecognizer){
        if let shapeView = sender.view {
            shapeView.transform = CGAffineTransformScale(shapeView.transform,
                sender.scale, sender.scale)
            sender.scale = 1
        }
    }
    
        //Pre-conditon: corners is an array with count of 9
        // Symbols       Indexes
        //o---^---o     0---5---2
        //<---*--->     1---8---3
        //o---v---o     6---7---4
    func placeCorners(corners: [UIImageView], selectedShape: UIView)-> [UIImageView]{
        //place the diagonal corners (o)
        corners[0].center.x = selectedShape.frame.minX
        corners[0].center.y = selectedShape.frame.minY
        corners[2].center.x = selectedShape.frame.maxX
        corners[2].center.y = selectedShape.frame.minY
        corners[6].center.x = selectedShape.frame.minX
        corners[6].center.y = selectedShape.frame.maxY
        corners[4].center.x = selectedShape.frame.maxX
        corners[4].center.y = selectedShape.frame.maxY
        
        //place the horizontal corners (< >)
        corners[1].center.x = selectedShape.frame.minX
        corners[1].center.y = selectedShape.frame.midY
        corners[3].center.x = selectedShape.frame.maxX
        corners[3].center.y = selectedShape.frame.midY
        
        //place the vertical corners (^ v)
        corners[5].center.x = selectedShape.frame.midX
        corners[5].center.y = selectedShape.frame.minY
        corners[7].center.x = selectedShape.frame.midX
        corners[7].center.y = selectedShape.frame.maxY
        
        //place the center (*)
        corners[8].center = selectedShape.center
        
        return corners
    }
    
    //ColorSlider Events
    func willChangeColor(slider: ColorSlider) {
        canvas.userInteractionEnabled = false
    }
    
   	func isChangingColor(slider: ColorSlider) {
        colorBarButton.tintColor = colorSlider.color
    }
    
    func didChangeColor(slider: ColorSlider) {
        colorBarButton.tintColor = colorSlider.color
        shapeColor = colorSlider.color
        canvas.userInteractionEnabled = true
    }
    
    //Toolbar functions
    func draw(sender: UIBarButtonItem){
        drawMode = !drawMode
        if drawMode{
            drawBarButton.tintColor = fontColor
        } else{
            drawBarButton.tintColor = barButtonColor
        }
    }
    
    func color(sender: UIBarButtonItem){
        colorMode = !colorMode
        
        if colorMode{
            colorBarButton.tintColor = fontColor
            UIView.animateWithDuration(0.5, animations: {
                self.colorSlider.center.x = self.view.bounds.width - self.colorSlider.bounds.width/2
            })
        } else{
            colorBarButton.tintColor = shapeColor
            UIView.animateWithDuration(0.5, animations: {
                self.colorSlider.center.x = self.view.bounds.width + self.colorSlider.bounds.width/2
            })
        }
    }
    
    func resize(sender: UIBarButtonItem){
        resizeMode = !resizeMode
        
        if resizeMode{
            resizeBarButton.tintColor = fontColor
            UIView.animateWithDuration(0.5, animations: {
                self.sizeToolbar.center.y = self.view.bounds.height - self.sizeToolbar.bounds.height/2
                self.toolbar.center.y = self.sizeToolbar.center.y - self.sizeToolbar.bounds.height/2 - self.toolbar.bounds.height/2
            })
        } else{
            resizeBarButton.tintColor = barButtonColor
            UIView.animateWithDuration(0.5, animations: {
                self.sizeToolbar.center.y = self.view.bounds.height + self.sizeToolbar.bounds.height/2
                self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
            })
            for corner in corners{
                corner.removeFromSuperview()
            }
            selectedShape = nil
        }
    }
    
    func erase(sender: UIBarButtonItem){
        eraseMode = !eraseMode
        
        if eraseMode{ //eraseMode on
            eraseBarButton.tintColor = fontColor
        }else{ //eraseMode off
            eraseBarButton.tintColor = barButtonColor
        }
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
            viewBarButton.tintColor = fontColor
        }
    }
    
    func deleteView(sender: UIBarButtonItem) {
        for rect in rectangles{
            rect.removeFromSuperview()
        }
        rectangles.removeAll()
    }
    
    func returnHome(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //Slider function
    func sliderValueChanged(sender: UISlider){
        let identifier = sender.tag
        switch identifier{
        case 1: //height
            height = Int(round(heightSlider.value))
            heightValueLabel.text = "\(height)"
        case 2: //square
            heightSlider.value = squareSlider.value
            widthSlider.value = squareSlider.value
            height = Int(round(squareSlider.value))
            width = Int(round(squareSlider.value))
            heightValueLabel.text = "\(height)"
            widthValueLabel.text = "\(width)"
            squareValueLabel.text = "\(width)"
        case 3: //width
            width = Int(round(widthSlider.value))
            widthValueLabel.text = "\(width)"
        default: //height
            height = Int(round(heightSlider.value))
            heightValueLabel.text = "\(height)"
        }
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
