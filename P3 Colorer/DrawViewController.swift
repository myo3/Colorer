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
    var shapesOnCanvas: Set<UIView> = Set<UIView>()
    var shapeView: UIView = UIView()
    
    var toolbar: UIToolbar = UIToolbar()
    var barButtonColor: UIColor?
    var drawBarButton = UIBarButtonItem()
    var eraseBarButton = UIBarButtonItem()
    var editBarButton = UIBarButtonItem()
    var hideBarButton = UIBarButtonItem()

    var drawMode: Bool = false
    var eraseMode: Bool = false
    var colorMode: Bool = false
    var editMode: Bool = false
    var hiddenMode: Bool = false
    var toolbarExpanded: Bool = false
    
    var drawToolbar: UIView = UIView()
    var heightSlider: UISlider = UISlider()
    var widthSlider: UISlider = UISlider()
    var heightValueLabel: UILabel = UILabel()
    var widthValueLabel: UILabel = UILabel()
    
    var editToolbar: UIView = UIView()
    var colorSlider: ColorSlider = ColorSlider()
    var newColorPreview: UIImageView = UIImageView()
    var curColorPreview: UIImageView = UIImageView()
    
    var selectedShape: UIView?
    var corners: [UIImageView] = [UIImageView]()
    // Symbols       Indexes/Tags
    //o---^---o     0---1---2
    //<---*--->     7---8---3
    //o---v---o     6---5---4
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create bar buttons
        let backBarButton = UIBarButtonItem(image: UIImage(named: "blackBack"), style: .Plain, target: self, action: "returnHome:")
        backBarButton.tintColor = barButtonColor
        let deleteBarButton = UIBarButtonItem(image: UIImage(named: "greyDelete"), style: .Plain, target: self, action: "deleteView:")
        deleteBarButton.tintColor = barButtonColor
        drawBarButton = UIBarButtonItem(image: UIImage(named: "greyDraw"), style: .Plain, target: self, action: "draw:")
        drawBarButton.tintColor = barButtonColor
        eraseBarButton = UIBarButtonItem(image: UIImage(named: "greyErase"), style: .Plain, target: self, action: "erase:")
        eraseBarButton.tintColor = barButtonColor
        editBarButton = UIBarButtonItem(image: UIImage(named: "greyResize"), style: .Plain, target: self, action: "edit:")
        editBarButton.tintColor = barButtonColor
        hideBarButton = UIBarButtonItem(image: UIImage(named: "greyView"), style: .Plain, target: self, action: "view:")
        hideBarButton.tintColor = barButtonColor
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem:
            .FlexibleSpace, target: self, action: nil)
        
        //set up toolbar
        let toolbarItems = [backBarButton, flexibleSpace, drawBarButton, flexibleSpace, eraseBarButton, flexibleSpace, editBarButton, flexibleSpace, hideBarButton, flexibleSpace, deleteBarButton]
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

        let heightLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        let widthLabel = UILabel(frame: CGRectMake(sliderSpace, 0, labelWidth, labelHeight))
        heightLabel.center.y = sliderCenterY*3
        widthLabel.center.y = sliderCenterY*5
        heightLabel.textAlignment = NSTextAlignment.Right
        widthLabel.textAlignment = NSTextAlignment.Right
        heightLabel.textColor = barButtonColor
        widthLabel.textColor = barButtonColor
        heightLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightLabel.text = "HEIGHT"
        widthLabel.text = "WIDTH"
        drawToolbar.addSubview(heightLabel)
        drawToolbar.addSubview(widthLabel)
        
        //set up sliders
        let sliderWidth = drawToolbar.bounds.width - (2*sliderSpace) - labelWidth - (2*sliderSpace) - valueLabelWidth
        let sliderHeight = CGFloat(31)
        heightSlider = UISlider(frame: CGRectMake(heightLabel.frame.maxX + sliderSpace, 0, sliderWidth, sliderHeight))
        widthSlider = UISlider(frame: CGRectMake(widthLabel.frame.maxX + sliderSpace, 0, sliderWidth, sliderHeight))
        heightSlider.maximumValue = 100
        widthSlider.maximumValue = 100
        heightSlider.value = Float(height)
        widthSlider.value = Float(width)
        heightSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        widthSlider.addTarget(self, action: "sliderValueChanged:", forControlEvents: .ValueChanged)
        heightSlider.tag = 1
        widthSlider.tag = 2
        heightSlider.center.y = heightLabel.center.y
        widthSlider.center.y = widthLabel.center.y
        heightSlider.minimumTrackTintColor = barButtonColor
        widthSlider.minimumTrackTintColor = barButtonColor
        heightSlider.maximumTrackTintColor = fontColor
        widthSlider.maximumTrackTintColor = fontColor
        heightSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbHeight")!, forState: .Normal)
        widthSlider.setThumbImage(UIImage(named: "\(selected!)SliderThumbWidth")!, forState: .Normal)
        drawToolbar.addSubview(heightSlider)
        drawToolbar.addSubview(widthSlider)
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "dismissToolbar:")
        swipeUp.direction = .Up
        toolbar.addGestureRecognizer(swipeUp)
        
        //set up slider value labels
        heightValueLabel = UILabel(frame: CGRectMake(heightSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        widthValueLabel = UILabel(frame: CGRectMake(widthSlider.frame.maxX + sliderSpace, 0, valueLabelWidth, labelHeight))
        heightValueLabel.center.y = heightLabel.center.y
        widthValueLabel.center.y = widthLabel.center.y
        heightValueLabel.textAlignment = NSTextAlignment.Left
        widthValueLabel.textAlignment = NSTextAlignment.Left
        heightValueLabel.textColor = barButtonColor
        widthValueLabel.textColor = barButtonColor
        heightValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        widthValueLabel.font = UIFont(name: "ArcaMajora-Heavy", size: 18)
        heightValueLabel.text = "\(height)"
        widthValueLabel.text = "\(width)"
        drawToolbar.addSubview(heightValueLabel)
        drawToolbar.addSubview(widthValueLabel)
        
        //set up edit toolbar
        editToolbar = UIView(frame: CGRectMake(0, view.bounds.height, view.bounds.width, view.bounds.height/6))
        editToolbar.layer.contents = UIImage(named: "\(selected!)SizeToolbar")!.CGImage
        self.view.addSubview(editToolbar)
            //set up color slider
        colorSlider = ColorSlider(frame: CGRectMake(0, 0, view.bounds.width, sliderHeight))
        colorSlider.center = CGPoint(x: editToolbar.bounds.width/2, y: editToolbar.bounds.height*0.75)
        colorSlider.orientation = ColorSliderOrientation.Horizontal
        colorSlider.borderColor = barButtonColor!
        colorSlider.addTarget(self, action: "willChangeColor:", forControlEvents: .TouchDown)
        colorSlider.addTarget(self, action: "isChangingColor:", forControlEvents: .ValueChanged)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpOutside)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpInside)
        editToolbar.addSubview(colorSlider)
            //set up color preview
        let colorPreviewSize = editToolbar.bounds.height*0.4
        newColorPreview = UIImageView(frame: CGRectMake(editToolbar.bounds.width/2 - colorPreviewSize/2, 0, colorPreviewSize/2, colorPreviewSize))
        curColorPreview = UIImageView(frame: CGRectMake(editToolbar.bounds.width/2, 0, colorPreviewSize/2, colorPreviewSize))
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
        editToolbar.addSubview(newColorPreview)
        editToolbar.addSubview(curColorPreview)
        
        //set up corners: set color, add pan feature, count = 9
        for i in 0...8 {
            let corner = UIImageView(frame: CGRectMake(0, 0, 10, 10))
            corner.backgroundColor = fontColor
            corners.append(corner)
            corner.tag = i
            corner.userInteractionEnabled = true
            if i == 8{
                continue
            }
            let pan = UIPanGestureRecognizer(target: self, action: "resizeShape:")
            corner.addGestureRecognizer(pan)
        }
        
        //set up rotate corner
        corners[8].backgroundColor = UIColor.clearColor()
        corners[8].image = UIImage(named: "rotateIcon")
        corners[8].contentMode = UIViewContentMode.ScaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: "tapToRotate:")
        corners[8].addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !eraseMode && !hiddenMode && drawMode{ //eraseMode off, not hidden, draw on
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
            let pan = UIPanGestureRecognizer(target: self, action: "moveShape:")
            shapeView.addGestureRecognizer(tap)
            shapeView.addGestureRecognizer(pan)
            //add shape to view
            if !CGRectIntersectsRect(shapeView.frame, drawToolbar.frame){
                canvas.addSubview(shapeView)
                //add shape to rectangles array
                shapesOnCanvas.insert(shapeView)
            }
        }
    }
    
    //Shape functions
    func moveShape(sender: UIPanGestureRecognizer){
        let corner = sender.view!
        let trans = sender.translationInView(canvas)
        corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
        sender.setTranslation(CGPointZero, inView: canvas)
    }
    
    func tapToRotate(sender: UITapGestureRecognizer){
        //if there is a selectedShape
        if let shapeView = selectedShape{
            let rotation = CGFloat(M_PI/2)
            shapeView.transform = CGAffineTransformRotate(shapeView.transform, rotation)
            corners = placeCorners(corners, selectedShape: shapeView)
            
        }
    }
    
    func tapShape(sender: UITapGestureRecognizer){
        selectedShape = sender.view!
        
        if editMode{
            //place each corner in view
            for corner in corners {
                self.view.insertSubview(corner, aboveSubview: selectedShape!)
            }
            
            //place each corner in proper place
            corners = placeCorners(corners, selectedShape: selectedShape!)
        }
        
        if eraseMode{
            if shapesOnCanvas.contains(selectedShape!) {
                shapesOnCanvas.remove(selectedShape!)
                selectedShape!.removeFromSuperview()
            }
        }
    }
    
    func resizeShape(sender: UIPanGestureRecognizer){
        let corner = sender.view as! UIImageView
        
        //resize shape
        let trans = sender.translationInView(canvas)
        switch corner.tag{
        case 0: //works, combine 7 & 1
            corner.center.x = corner.center.x + trans.x
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.center.x = shape.center.x + trans.x
                shape.frame.size.height = shape.frame.height - trans.y
                shape.center.y = shape.center.y + trans.y
            }
        case 1: //works
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.height = shape.frame.height - trans.y
                shape.center.y = shape.center.y + trans.y
            }
        case 2: //works, combine 1 & 3
            corner.center.x = corner.center.x + trans.x
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width + trans.x
                shape.frame.size.height = shape.frame.height - trans.y
                shape.center.y = shape.center.y + trans.y
            }
        case 3: //works
            corner.center.x = corner.center.x + trans.x
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width + trans.x
            }
        case 4: //works, combine 5 & 3
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            if let shape = selectedShape{
                shape.frame.size = CGSize(width: shape.frame.width + trans.x , height: shape.frame.height + trans.y)
            }
        case 5: //works
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.height = shape.frame.height + trans.y
            }
        case 6: //works, combine 7 & 5
            corner.center.x = corner.center.x + trans.x
            corner.center.y = corner.center.y + trans.y
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.frame.size.height = shape.frame.height + trans.y
                shape.center.x = shape.center.x + trans.x
            }
        case 7: //works
            corner.center.x = corner.center.x + trans.x
            if let shape = selectedShape{
                shape.frame.size.width = shape.frame.width - trans.x
                shape.center.x = shape.center.x + trans.x
            }
        default:
            corner.center = CGPoint(x: corner.center.x + trans.x, y: corner.center.y + trans.y)
            selectedShape?.center = CGPoint(x: (selectedShape?.center.x)! + trans.x, y: (selectedShape?.center.y)! + trans.y)
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
        
        //place the center (*)
        corners[8].center = selectedShape.center
        
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
    func draw(sender: UIBarButtonItem){
        drawMode = !drawMode
        if drawMode{
            //turn off other buttons
            if eraseMode{
                UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
            }
            if editMode{
                UIApplication.sharedApplication().sendAction(editBarButton.action, to: editBarButton.target, from: self, forEvent: nil)
            }
            if hiddenMode{
                UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
            }
            
            //draw mode stuff
            drawBarButton.tintColor = fontColor
            toolbarExpanded = true
            UIView.animateWithDuration(0.5, animations: {
                self.drawToolbar.center.y = self.view.bounds.height - self.drawToolbar.bounds.height/2
                self.toolbar.center.y = self.drawToolbar.center.y - self.drawToolbar.bounds.height/2 - self.toolbar.bounds.height/2
            })
        } else{
            drawBarButton.tintColor = barButtonColor
            toolbarExpanded = false
            UIView.animateWithDuration(0.5, animations: {
                self.drawToolbar.center.y = self.view.bounds.height + self.drawToolbar.bounds.height/2
                self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
            })
        }
    }
    
    func dismissToolbar(gestureRecognizer: UISwipeGestureRecognizer) {
        toolbarExpanded = !toolbarExpanded
        if toolbarExpanded{
            if drawMode{ //present drawToolbar
                UIView.animateWithDuration(0.5, animations: {
                    self.drawToolbar.center.y = self.view.bounds.height - self.drawToolbar.bounds.height/2
                    self.toolbar.center.y = self.drawToolbar.center.y - self.drawToolbar.bounds.height/2 - self.toolbar.bounds.height/2
                })
            }
            if editMode{ //present editToolbar
                UIView.animateWithDuration(0.5, animations: {
                    self.editToolbar.center.y = self.view.bounds.height - self.editToolbar.bounds.height/2
                    self.toolbar.center.y = self.editToolbar.center.y - self.editToolbar.bounds.height/2 - self.toolbar.bounds.height/2
                })
            }
        }else{
            if drawMode{
                UIView.animateWithDuration(0.5, animations: {
                    self.drawToolbar.center.y = self.view.bounds.height + self.drawToolbar.bounds.height/2
                    self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
                })
            }
            if editMode{
                UIView.animateWithDuration(0.5, animations: {
                    self.editToolbar.center.y = self.view.bounds.height + self.editToolbar.bounds.height/2
                    self.toolbar.center.y = self.view.bounds.height - self.toolbar.bounds.height/2
                })
            }
            
        }
    }
    
    func edit(sender: UIBarButtonItem){
        editMode = !editMode
        
        if editMode{
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
            
            //edit mode stuff
            editBarButton.tintColor = fontColor
            toolbarExpanded = true
            UIView.animateWithDuration(0.5, animations: {
                self.editToolbar.center.y = self.view.bounds.height - self.editToolbar.bounds.height/2
                self.toolbar.center.y = self.editToolbar.center.y - self.editToolbar.bounds.height/2 - self.toolbar.bounds.height/2
            })
        } else{
            editBarButton.tintColor = barButtonColor
            toolbarExpanded = false
            UIView.animateWithDuration(0.5, animations: {
                self.editToolbar.center.y = self.view.bounds.height + self.editToolbar.bounds.height/2
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
            //turn off other buttons
            if editMode{
                UIApplication.sharedApplication().sendAction(editBarButton.action, to: editBarButton.target, from: self, forEvent: nil)
            }
            if drawMode{
                UIApplication.sharedApplication().sendAction(drawBarButton.action, to: drawBarButton.target, from: self, forEvent: nil)
            }
            if hiddenMode{
                UIApplication.sharedApplication().sendAction(hideBarButton.action, to: hideBarButton.target, from: self, forEvent: nil)
            }
            eraseBarButton.tintColor = fontColor
        }else{ //eraseMode off
            eraseBarButton.tintColor = barButtonColor
        }
    }
    
    func view(sender: UIBarButtonItem){
        hiddenMode = !hiddenMode
        
        if hiddenMode{
            //turn off other buttons
            if editMode{
                UIApplication.sharedApplication().sendAction(editBarButton.action, to: editBarButton.target, from: self, forEvent: nil)
            }
            if drawMode{
                UIApplication.sharedApplication().sendAction(drawBarButton.action, to: drawBarButton.target, from: self, forEvent: nil)
            }
            if eraseMode{
                UIApplication.sharedApplication().sendAction(eraseBarButton.action, to: eraseBarButton.target, from: self, forEvent: nil)
            }
            
            //hidden mode stuff
            for rect in shapesOnCanvas{
                rect.alpha = 0
            }
            hideBarButton.tintColor = fontColor
        }else{
            for rect in shapesOnCanvas{
                rect.alpha = 1
            }
            hideBarButton.tintColor = barButtonColor
        }
    }
    
    func deleteView(sender: UIBarButtonItem) {
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
