//
//  ShapeViewController.swift
//  Project3
//
//  Created by Monica Ong on 10/7/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class ShapeViewController: UIViewController {
    var color: UIColor?
    var redValue: CGFloat = 0.08
    var greenValue: CGFloat = 0.61
    var blueValue: CGFloat = 0.08
    var alphaValue: CGFloat = 1
    
    var shapeView: UIView = UIView()
    var shape: String?
    
    @IBOutlet weak var squareSlider: UISlider!
    @IBOutlet weak var squareSizeLabel: UILabel!
    var squareValue: Int = 60
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    var heightValue: Int = 60
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthLabel: UILabel!
    var widthValue: Int = 60
    
    @IBOutlet weak var subviewSwitch: UISwitch!
    @IBOutlet weak var subviewSwitchLabel: UILabel!
    
    var rectangles: Set<UIView> = Set<UIView>()
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var alphaSlider: UISlider!
    @IBOutlet weak var alphaLabel: UILabel!
    
    @IBOutlet weak var eraseSwitch: UISwitch!
    @IBOutlet weak var eraseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateColorSliderValues()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateColorSliderValues(){
        redSlider.value = Float(redValue)
        redLabel.text = String(redValue)
        
        greenSlider.value = Float(greenValue)
        greenLabel.text = String(greenValue)
        
        blueSlider.value = Float(blueValue)
        blueLabel.text = String(blueValue)
        
        alphaSlider.value = Float(alphaValue)
        alphaLabel.text = String(alphaValue)
    }
    
    @IBAction func dismissModal(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if eraseSwitch.on{
            let location = touches.first!.locationInView(view)
            if shape == "Triangle"{
                shapeView = TriangleView(frame: CGRect(x: 0, y: 0, width: widthValue, height: heightValue))
                
            }
            else{
                shapeView = UIView(frame: CGRect(x: 0, y: 0, width: widthValue, height: heightValue))
                shapeView.layer.cornerRadius = 10
            }
            shapeView.center = location
            if color == nil{
                redValue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
                greenValue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
                blueValue = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
                updateColorSliderValues()
                shapeView.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
            } else{
                shapeView.backgroundColor = color
            }
            view.addSubview(shapeView)
            rectangles.insert(shapeView)
            
        } else{
            if let touch: UITouch! = touches.first!{
                if rectangles.contains(touch.view!) {
                    rectangles.remove(touch.view!)
                    touch.view?.removeFromSuperview()
                }
            }
        }
    }
    @IBAction func subviewSwitchPressed(sender: UISwitch) {
        if subviewSwitch.on{
            for rect in rectangles {
                rect.alpha = 1
                alphaSlider.value = 1
                alphaLabel.text = "1"
            }
            subviewSwitchLabel.text = "Hide All Subviews"
        } else{
            for rect in rectangles {
                rect.alpha = 0
                alphaSlider.value = 0
                alphaLabel.text = "0"
            }
            subviewSwitchLabel.text = "Show All Subviews"
        }
    }
    
    @IBAction func eraseSwitchPressed(sender: UISwitch) {
        if eraseSwitch.on{
            eraseLabel.text = "Erase"
        } else{
            eraseLabel.text = "Draw"
        }
    }
    
    @IBAction func squareSliderValueChanged(sender: UISlider) {
        squareValue = Int(round(squareSlider.value))
        squareSizeLabel.text = String(squareValue)
        
        heightValue = squareValue
        heightSlider.setValue(Float(squareValue), animated: true)
        heightLabel.text = squareSizeLabel.text
        
        widthValue = squareValue
        widthSlider.setValue(Float(squareValue), animated: true)
        widthLabel.text = squareSizeLabel.text
    }
    
    @IBAction func heightSliderValueChanged(sender: UISlider) {
        heightValue = Int(round(heightSlider.value))
        heightLabel.text = String(heightValue)
    }
    
    @IBAction func widthValueChanged(sender: UISlider) {
        widthValue = Int(round(widthSlider.value))
        widthLabel.text = String(widthValue)
    }
    
    @IBAction func redSliderValueChanged(sender: UISlider) {
        redValue = CGFloat(redSlider.value)
        changeColor()
        redLabel.text = String(redSlider.value)
    }
    
    @IBAction func greenSliderValueChanged(sender: UISlider) {
        greenValue = CGFloat(greenSlider.value)
        changeColor()
        greenLabel.text = String(greenSlider.value)
    }
    
    @IBAction func blueSliderValueChanged(sender: UISlider) {
        blueValue = CGFloat(blueSlider.value)
        changeColor()
        blueLabel.text = String(blueSlider.value)
    }
    
    @IBAction func alphaSliderValueChanged(sender: UISlider) {
        alphaValue = CGFloat(alphaSlider.value)
        changeColor()
        alphaLabel.text = String(alphaSlider.value)
    }
    
    func changeColor(){
        for rect in rectangles{
            rect.backgroundColor = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
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
