//
//  DrawViewController.swift
//  P3 Colorer
//
//  Created by Monica Ong on 12/15/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit
import Social

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(UIColor.clearColor()), forState: .Normal, barMetrics: .Default)
        setBackgroundImage(imageWithColor(UIColor.clearColor()), forState: .Selected, barMetrics: .Default)
        setDividerImage(imageWithColor(UIColor.clearColor()), forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: .Default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}

class DrawViewController: UIViewController {
    var selected: String?
    
    var colorGreyLight: UIColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    var colorGreyDark: UIColor = UIColor(red:0.21, green:0.22, blue:0.22, alpha:1.0)
    
    var canvas: UIView = UIView()
    var shapeType: String?
    var shapeColor: UIColor = UIColor(red:0.21, green:0.22, blue:0.22, alpha:1.0) //colorGreyDark
    var height: Int = 100
    var width: Int = 100
    var shapesOnCanvas: Set<UIView> = Set<UIView>()
    var shapeView: UIView = UIView()
    
    var toolbar: UIToolbar = UIToolbar()
    var drawBarButton = UIBarButtonItem()
    var eraseBarButton = UIBarButtonItem()
    var colorBarButton = UIBarButtonItem()
    var hideBarButton = UIBarButtonItem()
    var deleteBarButton = UIBarButtonItem()

    var randomMode: Bool = false
    var drawMode: Bool = false
    var eraseMode: Bool = false
    var colorMode: Bool = false
    var hiddenMode: Bool = false
    var toolbarExpanded: Bool = false
    
    var drawToolbar: UIView = UIView()
    var shapeSelector: UISegmentedControl = UISegmentedControl()
    var segments: [UIView] = [UIView]()
    var heightSlider: UISlider = UISlider()
    var widthSlider: UISlider = UISlider()
    var heightValueLabel: UILabel = UILabel()
    var widthValueLabel: UILabel = UILabel()
    
    var colorToolbar: UIView = UIView()
    var colorSlider: ColorSlider = ColorSlider()
    var newColorPreview: UIImageView = UIImageView()
    var curColorPreview: UIImageView = UIImageView()
    
    var selectedShape: UIView?
    var corners: [UIImageView] = [UIImageView]()
    let cornerSize = CGFloat(17)
    let cornerButtonSpace = CGFloat(10)
    
    var shareTransitionManager = ShareTransitionManager()
    var shareButton: UIButton = UIButton()
    
    
    // Symbols       Indexes/Tags
    //o---^---o     0---1---2
    //<---*--->     7---8---3
    //o---v---o     6---5---4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set up bar buttons
        let backBarButton = UIBarButtonItem(image: UIImage(named: "blackBack"), style: .Plain, target: self, action: "returnHome:")
        backBarButton.tintColor = colorGreyDark
        deleteBarButton = UIBarButtonItem(image: UIImage(named: "greyDelete"), style: .Plain, target: self, action: "deleteView:")
        deleteBarButton.tintColor = colorGreyDark
        drawBarButton = UIBarButtonItem(image: UIImage(named: "greyDraw"), style: .Plain, target: self, action: "draw:")
        drawBarButton.tintColor = colorGreyDark
        eraseBarButton = UIBarButtonItem(image: UIImage(named: "greyErase"), style: .Plain, target: self, action: "erase:")
        eraseBarButton.tintColor = colorGreyDark
        colorBarButton = UIBarButtonItem(image: UIImage(named: "greyColor"), style: .Plain, target: self, action: "color:")
        colorBarButton.tintColor = colorGreyDark
        hideBarButton = UIBarButtonItem(image: UIImage(named: "greyView"), style: .Plain, target: self, action: "view:")
        hideBarButton.tintColor = colorGreyDark
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            .FlexibleSpace, target: self, action: nil)
        
        //set up toolbar
        let toolbarItems = [backBarButton, flexibleSpace, drawBarButton, flexibleSpace, eraseBarButton, flexibleSpace, colorBarButton, flexibleSpace, hideBarButton, flexibleSpace, deleteBarButton]
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
        
        //set up swiper
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "presentToolbar:")
        swipeUp.direction = .Up
//        swipeUp.delaysTouchesBegan = true
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "dismissToolbar")
        swipeDown.direction = .Down
//        swipeDown.delaysTouchesBegan = true
        canvas.addGestureRecognizer(swipeUp)
        canvas.addGestureRecognizer(swipeDown)
        
        //set up share button
        shareButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        shareButton.setTitle("C", forState: .Normal)
        shareButton.titleLabel?.font = UIFont(name: "ArcaMajora-Heavy", size: 40)
        shareButton.titleLabel?.textAlignment = .Center
        shareButton.setTitleColor(colorGreyDark, forState: .Normal)
        shareButton.center = CGPoint(x: view.bounds.width/2, y: 40)
        self.view.insertSubview(shareButton, aboveSubview: canvas)
        shareButton.addTarget(self, action: "share", forControlEvents: .TouchUpInside)
        let swipeToShare = UISwipeGestureRecognizer(target: self, action: "share")
        swipeToShare.direction = .Down
        shareButton.addGestureRecognizer(swipeToShare)
        
        //set up draw toolbar
        drawToolbar = UIView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, view.bounds.height/6))
        drawToolbar.layer.contents = UIImage(named: "\(selected!)SizeToolbar")!.CGImage
        self.view.addSubview(drawToolbar)
        
        //set up slider labels
        let sliderSpace = CGFloat(10)
        let sliderCenterY = drawToolbar.bounds.height/6
        let labelWidth = CGFloat(80)
        let labelHeight = CGFloat(21)
        let valueLabelWidth = CGFloat(43)
        
        let shapeTypeLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        let heightLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        let widthLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        shapeTypeLabel.center.y = sliderCenterY
        heightLabel.center.y = sliderCenterY*3
        widthLabel.center.y = sliderCenterY*5
        shapeTypeLabel.textAlignment = NSTextAlignment.Right
        heightLabel.textAlignment = NSTextAlignment.Right
        widthLabel.textAlignment = NSTextAlignment.Right
        shapeTypeLabel.textColor = colorGreyDark
        heightLabel.textColor = colorGreyDark
        widthLabel.textColor = colorGreyDark
        shapeTypeLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        shapeTypeLabel.text = "SHAPE"
        heightLabel.text = "HEIGHT"
        widthLabel.text = "WIDTH"
        drawToolbar.addSubview(shapeTypeLabel)
        drawToolbar.addSubview(heightLabel)
        drawToolbar.addSubview(widthLabel)
        
        //set up sliders
        let sliderWidth = drawToolbar.bounds.width - (2*sliderSpace) - labelWidth - (2*sliderSpace) - valueLabelWidth
        let sliderHeight = CGFloat(31)
        heightSlider = UISlider(frame: CGRectMake(heightLabel.frame.maxX + sliderSpace, 0, sliderWidth, sliderHeight))
        widthSlider = UISlider(frame: CGRectMake(widthLabel.frame.maxX + sliderSpace, 0, sliderWidth, sliderHeight))
        heightSlider.center.y = heightLabel.center.y
        widthSlider.center.y = widthLabel.center.y
        heightSlider.minimumValue = Float(cornerSize*4 + cornerButtonSpace*2)
        widthSlider.minimumValue = Float(cornerSize*4 + cornerButtonSpace*2)
        heightSlider.maximumValue = 200
        widthSlider.maximumValue = 200
        heightSlider.value = Float(height)
        widthSlider.value = Float(width)
        heightSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        widthSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        heightSlider.tag = 1
        widthSlider.tag = 2
        heightSlider.minimumTrackTintColor = colorGreyDark
        widthSlider.minimumTrackTintColor = colorGreyDark
        heightSlider.maximumTrackTintColor = colorGreyLight
        widthSlider.maximumTrackTintColor = colorGreyLight
        heightSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbHeight")!, forState: .Normal)
        widthSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbWidth")!, forState: .Normal)
        drawToolbar.addSubview(heightSlider)
        drawToolbar.addSubview(widthSlider)
        
        //set up slider value labels
        heightValueLabel = UILabel(frame: CGRectMake(heightSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        widthValueLabel = UILabel(frame: CGRectMake(widthSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        heightValueLabel.center.y = heightLabel.center.y
        widthValueLabel.center.y = widthLabel.center.y
        heightValueLabel.textAlignment = NSTextAlignment.Left
        widthValueLabel.textAlignment = NSTextAlignment.Left
        heightValueLabel.textColor = colorGreyDark
        widthValueLabel.textColor = colorGreyDark
        heightValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightValueLabel.text = "\(height)"
        widthValueLabel.text = "\(width)"
        drawToolbar.addSubview(heightValueLabel)
        drawToolbar.addSubview(widthValueLabel)
        
        //set up shape selector
        let types = ["rectangle", "circle", "triangle"]
        shapeSelector = UISegmentedControl(items: types)
        shapeSelector.frame = CGRectMake(shapeTypeLabel.frame.maxX + sliderSpace, 0, sliderHeight*3 + 30, sliderHeight)
        shapeSelector.center.y = shapeTypeLabel.center.y
        shapeSelector.tintColor = colorGreyDark
        shapeSelector.removeBorders()
        shapeSelector.addTarget(self, action: "selectShape:", forControlEvents: .ValueChanged)
        shapeSelector.setImage(UIImage(named: "rectangle"), forSegmentAtIndex: 0)
        shapeSelector.setImage(UIImage(named: "circle"), forSegmentAtIndex: 1)
        shapeSelector.setImage(UIImage(named: "triangle"), forSegmentAtIndex: 2)
        for i in 0...shapeSelector.subviews.count-1{
            segments.append(shapeSelector.subviews[i])
        }
        shapeSelector.selectedSegmentIndex = types.indexOf(shapeType ?? "rectangle") ?? 0//default: select rectangle
        segments[shapeSelector.selectedSegmentIndex].tintColor = colorGreyLight
        shapeSelector.contentMode = UIViewContentMode.ScaleAspectFit
        drawToolbar.addSubview(shapeSelector)
        
        //set up random button
        let randomButton = UIButton(frame: CGRectMake(heightSlider.frame.maxX + sliderSpace, 0, sliderHeight, sliderHeight))
        randomButton.center.y = shapeSelector.center.y
        let image = UIImage(named: "randomize")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        randomButton.setImage(image, forState: UIControlState.Normal)
        randomButton.tintColor = colorGreyDark
        randomButton.addTarget(self, action: "randomize:", forControlEvents: .TouchUpInside)
        drawToolbar.addSubview(randomButton)
        
        //set up color toolbar
        colorToolbar = UIView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, view.bounds.height/6))
        colorToolbar.layer.contents = UIImage(named: "\(selected!)SizeToolbar")!.CGImage
        self.view.addSubview(colorToolbar)
        
        //set up color slider
        colorSlider = ColorSlider(frame: CGRectMake(0, 0, view.bounds.width, sliderHeight))
        colorSlider.center = CGPoint(x: colorToolbar.bounds.width/2, y: colorToolbar.bounds.height*0.75)
        colorSlider.orientation = ColorSliderOrientation.Horizontal
        colorSlider.borderColor = colorGreyDark
        colorSlider.addTarget(self, action: "willChangeColor:", forControlEvents: .TouchDown)
        colorSlider.addTarget(self, action: "isChangingColor:", forControlEvents: .ValueChanged)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpOutside)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpInside)
        colorToolbar.addSubview(colorSlider)
            //set up color preview
        let colorPreviewSize = colorToolbar.bounds.height*0.4
        newColorPreview = UIImageView(frame: CGRectMake(colorToolbar.bounds.width/2 - colorPreviewSize/2, 0, colorPreviewSize/2, colorPreviewSize))
        curColorPreview = UIImageView(frame: CGRectMake(colorToolbar.bounds.width/2, 0, colorPreviewSize/2, colorPreviewSize))
        newColorPreview.center.y = colorSlider.frame.minY/2
        curColorPreview.center.y = colorSlider.frame.minY/2
        newColorPreview.image = UIImage(named: "blackColorLeft")
        curColorPreview.image = UIImage(named: "blackColorRight")
        newColorPreview.image =  newColorPreview.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        newColorPreview.tintColor = shapeColor
        curColorPreview.image = curColorPreview.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        curColorPreview.tintColor = shapeColor
        newColorPreview.contentMode = UIViewContentMode.ScaleAspectFit
        curColorPreview.contentMode = UIViewContentMode.ScaleAspectFit
        colorToolbar.addSubview(newColorPreview)
        colorToolbar.addSubview(curColorPreview)
        
        //set up corners: set color, add pan feature, count = 11
        for i in 0...10 {
            let corner = UIImageView(frame: CGRectMake(0, 0, cornerSize, cornerSize))
            corner.backgroundColor = colorGreyLight
            corners.append(corner)
            corner.tag = i
            corner.userInteractionEnabled = true
            if i >= 8{
                continue
            }
            let pan = UIPanGestureRecognizer(target: self, action: "resizeShape:")
            corner.addGestureRecognizer(pan)
        }
        
        //set up rotate corner
        corners[8].image = UIImage(named: "rotateIcon")
        let tapRotate = UITapGestureRecognizer(target: self, action: "tapToRotate:")
        corners[8].addGestureRecognizer(tapRotate)
        
        //set up move backward corner
        corners[9].image = UIImage(named: "moveBackward")
        let tapLayerB = UITapGestureRecognizer(target: self, action: "tapLayerShape:")
        corners[9].addGestureRecognizer(tapLayerB)
        
        //set up move forward corner
        corners[10].image = UIImage(named: "moveForward")
        let tapLayerF = UITapGestureRecognizer(target: self, action: "tapLayerShape:")
        corners[10].addGestureRecognizer(tapLayerF)
        
        //finalize shape grid functions
        for i in 8...10{
            corners[i].backgroundColor = UIColor.clearColor()
            corners[i].contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Draw on canvas
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInView(view)
        
        //only draw if in draw mode
        if drawMode{
            
            //if random mode on, calcualte shapeType, width & height
            var i = 0
            if randomMode{
                let type = ["rectangle", "circle", "triangle"]
                i = Int(arc4random_uniform(UInt32(type.count)))
                shapeType = type[i]
                width = Int(arc4random_uniform(UInt32(widthSlider.maximumValue - widthSlider.minimumValue) - 1) + UInt32(widthSlider.minimumValue))
                height = Int(arc4random_uniform(UInt32(heightSlider.maximumValue - heightSlider.minimumValue) - 1) + UInt32(heightSlider.minimumValue))
            }
            
            //create shape
            switch shapeType!{
            case "rectangle":
                shapeView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.layer.cornerRadius = 10
                shapeView.tag = 1
            case "circle":
                shapeView = OvalView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.tag = 2
            case "triangle":
                shapeView = TriangleView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.tag = 3
            default:
                shapeView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                shapeView.layer.cornerRadius = 10
            }

            //place shape where user touched
            shapeView.center = location
            
            //see if shape is placed in valid location
            if !CGRectIntersectsRect(shapeView.frame, drawToolbar.frame){
                if randomMode{
                    //calculate shape color
                    shapeColor = UIColor(red: CGFloat(arc4random()) / CGFloat(UINT32_MAX), green: CGFloat(arc4random()) / CGFloat(UINT32_MAX), blue: CGFloat(arc4random()) / CGFloat(UINT32_MAX), alpha: 1)
                    //update bar button to match new shape color
                    colorBarButton.tintColor = shapeColor
                    //update color previewer colors
                    curColorPreview.tintColor = shapeColor
                    newColorPreview.tintColor = shapeColor
                    
                    //update slider & sliders' label
                    widthSlider.value = Float(width)
                    heightSlider.value = Float(height)
                    widthValueLabel.text = "\(width)"
                    heightValueLabel.text = "\(height)"
                    
                    //update shape type
                    shapeSelector.selectedSegmentIndex = i
                    self.selectShape(shapeSelector)
                }
                //set shape color
                shapeView.backgroundColor = shapeColor
                
                //add gesture recognizers
                let swipeUp = UISwipeGestureRecognizer(target: self, action: "presentToolbar:")
                swipeUp.direction = .Up
                
                let swipeDown = UISwipeGestureRecognizer(target: self, action: "dismissToolbar")
                swipeDown.direction = .Down
                shapeView.addGestureRecognizer(swipeUp)
                shapeView.addGestureRecognizer(swipeDown)
                
                let tap = UITapGestureRecognizer(target: self, action: "tapShape:")
                let pan = UIPanGestureRecognizer(target: self, action: "moveShape:")
                pan.requireGestureRecognizerToFail(swipeUp)
                pan.requireGestureRecognizerToFail(swipeDown)
                shapeView.addGestureRecognizer(tap)
                shapeView.addGestureRecognizer(pan)
                
                //add shape view
                canvas.addSubview(shapeView)
                shapesOnCanvas.insert(shapeView)
            }
        }
    }
    
    //Shape functions
    func moveShape(sender: UIPanGestureRecognizer){
        let corner = sender.view!
        let trans = sender.translationInView(canvas)
        corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
        if let shape = selectedShape{
            corners = placeCorners(corners, selectedShape: shape)
        }
        sender.setTranslation(CGPointZero, inView: canvas)
    }
    
    func deselectShape(){
        if let _ = selectedShape{
            for corner in corners{
                corner.removeFromSuperview()
            }
            selectedShape = nil
        }
    }
    
    func tapToRotate(sender: UITapGestureRecognizer){
        //if there is a selectedShape
        if let shape = selectedShape{
            let rotation = CGFloat(M_PI/2)
            shape.transform = CGAffineTransformRotate(shape.transform, rotation)
            corners = placeCorners(corners, selectedShape: shape)
            
        }
    }
    
    func tapLayerShape(sender: UITapGestureRecognizer){
        let corner = sender.view as! UIImageView
        if let shape = selectedShape{
            let currentIndex = canvas.subviews.indexOf(shape)
            switch corner.tag{
            case 9: //bring one level down
                if currentIndex > 0{
                    canvas.exchangeSubviewAtIndex(currentIndex!, withSubviewAtIndex: currentIndex! - 1)
                }
            case 10: //bring one level up
                if currentIndex < canvas.subviews.count-1{
                    canvas.exchangeSubviewAtIndex(currentIndex!, withSubviewAtIndex: currentIndex! + 1)
                }
            default: //bring one level up
                canvas.exchangeSubviewAtIndex(currentIndex!, withSubviewAtIndex: currentIndex! + 1)
            }
        }
        
    }
    
    func tapShape(sender: UITapGestureRecognizer){
        selectedShape = sender.view!
        
        if eraseMode{
            if shapesOnCanvas.contains(selectedShape!) {
                shapesOnCanvas.remove(selectedShape!)
                selectedShape!.removeFromSuperview()
            }
        }else if !drawMode{ //if not drawing, place resize grid on tapped shape
            //place each corner in view
            for corner in corners {
//                self.view.insertSubview(corner, aboveSubview: selectedShape!)
                self.view.insertSubview(corner, belowSubview: toolbar)
            }
            
            //place each corner in proper place
            corners = placeCorners(corners, selectedShape: selectedShape!)
            
            if colorMode{
                selectedShape?.backgroundColor = shapeColor
            }
        }
    }
    
    // Symbols     Indexes/Tags
    //o---^---o     0---1---2
    //<---*--->     7---8---3
    //o---v---o     6---5---4
    func resizeShape(sender: UIPanGestureRecognizer){
        let corner = sender.view as! UIImageView
        
        //resize shape
        let trans = sender.translationInView(canvas)
        if let shape = selectedShape{
            let widthMinValue = CGFloat(widthSlider.minimumValue)
            let heightMinValue = CGFloat(heightSlider.minimumValue)
            switch corner.tag{
            case 0: //works, combine 7 & 1
                let newWidth = shape.frame.width - trans.x
                let newHeight = shape.frame.height - trans.y
                if newWidth >= widthMinValue && newHeight >= heightMinValue{
                    corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
                    shape.center = CGPoint(x: shape.center.x + trans.x, y: shape.center.y + trans.y)
                    shape.frame.size = CGSize(width: newWidth, height: newHeight)
                }
            case 1: //works
                let newHeight = shape.frame.height - trans.y
                if newHeight >= heightMinValue{
                    corner.center.y = corner.center.y + trans.y
                    shape.frame.size.height = newHeight
                    shape.center.y = shape.center.y + trans.y
                }
            case 2: //works, combine 1 & 3
                let newWidth = shape.frame.width + trans.x
                let newHeight = shape.frame.height - trans.y
                if newWidth >= widthMinValue && newHeight >= heightMinValue{
                    corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
                    shape.frame.size = CGSize(width: newWidth, height: newHeight)
                    shape.center.y = shape.center.y + trans.y
                }
            case 3: //works
                let newWidth = shape.frame.width + trans.x
                if newWidth >= widthMinValue{
                    corner.center.x = corner.center.x + trans.x
                    shape.frame.size.width = newWidth
                }
            case 4: //works, combine 5 & 3
                let newWidth = shape.frame.width + trans.x
                let newHeight = shape.frame.height + trans.y
                if newWidth >= widthMinValue && newHeight >= heightMinValue{
                    corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
                    shape.frame.size = CGSize(width: newWidth, height: newHeight)
                }
            case 5: //works
                let newHeight = shape.frame.height + trans.y
                if newHeight >= heightMinValue{
                    corner.center.y = corner.center.y + trans.y
                    shape.frame.size.height = newHeight
                }
            case 6: //works, combine 7 & 5
                let newWidth = shape.frame.width - trans.x
                let newHeight = shape.frame.height + trans.y
                if newWidth >= widthMinValue && newHeight >= heightMinValue{
                    corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
                    shape.frame.size = CGSize(width: newWidth, height: newHeight)
                    shape.center.x = shape.center.x + trans.x

                }
            case 7: //works
                let newWidth = shape.frame.width - trans.x
                if newWidth >= widthMinValue{
                    corner.center.x = corner.center.x + trans.x
                    shape.frame.size.width = newWidth
                    shape.center.x = shape.center.x + trans.x
                }
            default:
                corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
                shape.center = CGPoint(x: shape.center.x + trans.x, y: shape.center.y + trans.y)
            }
            
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
                    corner.backgroundColor = colorGreyLight
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
    
        //Pre-conditon: corners is an array with count of 9
        // Symbols       Indexes/Tags
        //o---^---o     0---1---2
        //<---*--->     7---8---3
        //o---v---o     6---5---4
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
        corners[7].center.x = selectedShape.frame.minX
        corners[7].center.y = selectedShape.frame.midY
        corners[3].center.x = selectedShape.frame.maxX
        corners[3].center.y = selectedShape.frame.midY
        
        //place the vertical corners (^ v)
        corners[1].center.x = selectedShape.frame.midX
        corners[1].center.y = selectedShape.frame.minY
        corners[5].center.x = selectedShape.frame.midX
        corners[5].center.y = selectedShape.frame.maxY
        
        //place the rotate corner (*)
        corners[8].center = selectedShape.center
        
        //place the move forward/backward corners
        corners[9].center = selectedShape.center
        corners[9].center.x = corners[9].center.x - cornerButtonSpace - corners[9].bounds.width/2 - corners[8].bounds.width/2
        corners[10].center = selectedShape.center
        corners[10].center.x = corners[10].center.x + cornerButtonSpace + corners[9].bounds.width/2 + corners[8].bounds.width/2
        
        return corners
    }
    
    //ColorSlider Events
    func willChangeColor(slider: ColorSlider) {
        canvas.userInteractionEnabled = false
    }
    
   	func isChangingColor(slider: ColorSlider) {
        newColorPreview.tintColor = colorSlider.color
    }
    
    func didChangeColor(slider: ColorSlider) {
        newColorPreview.tintColor = colorSlider.color
        curColorPreview.tintColor = colorSlider.color
        shapeColor = colorSlider.color
        if let shape = selectedShape{
            shape.backgroundColor = colorSlider.color
        }
        canvas.userInteractionEnabled = true
    }
    
    //Toolbar functions
    func share(){
        //dismiss toolbar if on
        dismissToolbar()
        deselectShape()
        shareButton.hidden = true
        
        //generate snapshot
        let window: UIWindow! = UIApplication.sharedApplication().keyWindow
        let windowImage = capture(window)
        
        //unhide "C" button
        shareButton.hidden = false
        
        //transition to ShareViewController
        let shareVC = ShareViewController()
        shareVC.drawVC = self
        shareVC.masterpiece = windowImage
        shareVC.transitioningDelegate  = self.shareTransitionManager
        presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func capture(window: UIWindow) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(window.frame.width, window.frame.height-toolbar.frame.height), window.opaque, UIScreen.mainScreen().scale)
        window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func draw(sender: UIBarButtonItem){
        drawMode = !drawMode
        if drawMode{
            //turn off other buttons
            if eraseMode{
                UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
            }
            if colorMode{
                UIApplication.sharedApplication().sendAction(colorBarButton.action, to: colorBarButton.target, from: self, forEvent: nil)
            }
            if hiddenMode{
                UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
            }
            deselectShape()
            shareButton.hidden = true
            
            //draw mode stuff
            drawBarButton.tintColor = colorGreyLight
            toolbarExpanded = true
            UIView.animateWithDuration(0.5, animations: {
                self.drawToolbar.center.y = self.view.bounds.height - self.drawToolbar.bounds.height/2
                self.toolbar.center.y = self.drawToolbar.center.y - self.drawToolbar.bounds.height/2 - self.toolbar.bounds.height/2
            })
        } else{
            //unhide sharebutton
            shareButton.hidden = false
            
            drawBarButton.tintColor = colorGreyDark
            toolbarExpanded = false
            UIView.animateWithDuration(0.5, animations: {
                self.drawToolbar.center.y = self.view.bounds.height + self.drawToolbar.bounds.height/2
                self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
            })
        }
    }
    
    func selectShape(sender: UISegmentedControl){
        let i = sender.selectedSegmentIndex
        for s in segments{
            s.tintColor = colorGreyDark
        }
        segments[i].tintColor = colorGreyLight
        
        switch i{
        case 0:
            shapeType = "rectangle"
        case 1:
            shapeType = "circle"
        case 2:
            shapeType = "triangle"
        default:
            shapeType = "rectangle"
        }
    }
    
    func randomize(sender: UIButton){
        randomMode = !randomMode
        if randomMode{
            sender.tintColor = colorGreyLight
        } else{
            sender.tintColor = colorGreyDark
        }
    }
    
    func color(sender: UIBarButtonItem){
        colorMode = !colorMode
        
        if colorMode{
            //turn off other buttons
            if eraseMode{
                UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
            }
            if drawMode{
                UIApplication.sharedApplication().sendAction(drawBarButton.action, to: drawBarButton.target, from: self, forEvent: nil)
            }
            if hiddenMode{
                UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
            }
            shareButton.hidden = true
            
            //edit mode stuff
            colorBarButton.tintColor = colorGreyLight
            toolbarExpanded = true
            UIView.animateWithDuration(0.5, animations: {
                self.colorToolbar.center.y = self.view.bounds.height - self.colorToolbar.bounds.height/2
                self.toolbar.center.y = self.colorToolbar.center.y - self.colorToolbar.bounds.height/2 - self.toolbar.bounds.height/2
            })
        } else{
            //unhide share button
            shareButton.hidden = false
            
            colorBarButton.tintColor = shapeColor
            toolbarExpanded = false
            UIView.animateWithDuration(0.5, animations: {
                self.colorToolbar.center.y = self.view.bounds.height + self.colorToolbar.bounds.height/2
                self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
            })
        }
    }
    
    func dismissToolbar() {
        toolbarExpanded = !toolbarExpanded
        if toolbarExpanded == false{
            if drawMode{
                UIView.animateWithDuration(0.5, animations: {
                    self.drawToolbar.center.y = self.view.bounds.height + self.drawToolbar.bounds.height/2
                    self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
                })
            }
            if colorMode{
                UIView.animateWithDuration(0.5, animations: {
                    self.colorToolbar.center.y = self.view.bounds.height + self.colorToolbar.bounds.height/2
                    self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
                })
            }
            
        }
    }
    
    func presentToolbar(gestureRecognizer: UISwipeGestureRecognizer){
        toolbarExpanded = !toolbarExpanded
        if toolbarExpanded{
            if drawMode{ //present drawToolbar
                UIView.animateWithDuration(0.5, animations: {
                    self.drawToolbar.center.y = self.view.bounds.height - self.drawToolbar.bounds.height/2
                    self.toolbar.center.y = self.drawToolbar.center.y - self.drawToolbar.bounds.height/2 - self.toolbar.bounds.height/2
                })
            }
            if colorMode{ //present editToolbar
                UIView.animateWithDuration(0.5, animations: {
                    self.colorToolbar.center.y = self.view.bounds.height - self.colorToolbar.bounds.height/2
                    self.toolbar.center.y = self.colorToolbar.center.y - self.colorToolbar.bounds.height/2 - self.toolbar.bounds.height/2
                })
            }
        }
    }
    
    func erase(sender: UIBarButtonItem){
        eraseMode = !eraseMode
        
        if eraseMode{ //eraseMode on
            //turn off other buttons
            if colorMode{
                UIApplication.sharedApplication().sendAction(colorBarButton.action, to: colorBarButton.target, from: self, forEvent: nil)
            }
            if drawMode{
                UIApplication.sharedApplication().sendAction(drawBarButton.action, to: drawBarButton.target, from: self, forEvent: nil)
            }
            if hiddenMode{
                UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
            }
            deselectShape()
            shareButton.hidden = true
            
            //erase stuff
            eraseBarButton.tintColor = colorGreyLight
        }else{ //eraseMode off
            eraseBarButton.tintColor = colorGreyDark
            
            //unhide share button
            shareButton.hidden = false
        }
    }
    
    func view(sender: UIBarButtonItem){
        hiddenMode = !hiddenMode
        
        if hiddenMode{
            //turn off other buttons
            if colorMode{
                UIApplication.sharedApplication().sendAction(colorBarButton.action, to: colorBarButton.target, from: self, forEvent: nil)
            }
            if eraseMode{
                UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
            }
            deselectShape()
            shareButton.hidden = true
            
            //hidden mode stuff
            for rect in shapesOnCanvas{
                rect.alpha = 0
            }
            hideBarButton.tintColor = colorGreyLight
        }else{
            //unhide share button only if draw mode is not on
            if !drawMode{
                shareButton.hidden = false

            }
            
            for rect in shapesOnCanvas{
                rect.alpha = 1
            }
            hideBarButton.tintColor = colorGreyDark
        }
    }
    
    func deleteView(sender: UIBarButtonItem) {
        //turn off other buttons, except draw
        if colorMode{
            UIApplication.sharedApplication().sendAction(colorBarButton.action, to: colorBarButton.target, from: self, forEvent: nil)
        }
        if hiddenMode{
            UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
        }
        if eraseMode{
            UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
        }
        deselectShape()
        
        //delete everything
        for rect in shapesOnCanvas{
            rect.removeFromSuperview()
        }
        shapesOnCanvas.removeAll()
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
        case 2: //width
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
