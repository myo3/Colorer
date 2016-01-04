//
//  TriangleView.swift
//  Project32
//
//  Created by Monica Ong on 10/15/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
//    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.    
//    override func drawRect(rect: CGRect) {
//        
//        // Get Height and Width
//        let layerHeight = self.layer.frame.height
//        let layerWidth = self.layer.frame.width
//        
//        // Create Path
//        let bezierPath = UIBezierPath()
//        
//        // Draw Points
//        bezierPath.moveToPoint(CGPointMake(0, layerHeight))
//        bezierPath.addLineToPoint(CGPointMake(layerWidth, layerHeight))
//        bezierPath.addLineToPoint(CGPointMake(layerWidth/2, 0))
//        bezierPath.addLineToPoint(CGPointMake(0, layerHeight))
//        bezierPath.closePath()
//        
//        // Mask to Path
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = bezierPath.CGPath
//        self.layer.mask = shapeLayer
//        
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTriangleMask()
    }
    
    private func layoutTriangleMask(){
        let mask = self.shapeMaskLayer()
        let bounds = self.bounds
        if mask.frame != bounds{
            mask.frame = bounds
            
            // Get Height and Width
            let maskHeight = mask.bounds.height
            let maskWidth = mask.bounds.width
            
            // Create Path
            let bezierPath = UIBezierPath()
            
            // Draw Triangle
            bezierPath.moveToPoint(CGPointMake(0, maskHeight))
            bezierPath.addLineToPoint(CGPointMake(maskWidth, maskHeight))
            bezierPath.addLineToPoint(CGPointMake(maskWidth/2, 0))
            bezierPath.addLineToPoint(CGPointMake(0, maskHeight))
            bezierPath.closePath()
            
            //Set mask path
            mask.path = bezierPath.CGPath
        }
        
    }
    
    private func shapeMaskLayer() -> CAShapeLayer {
        if let layer = self.layer.mask as? CAShapeLayer {
            return layer
        }
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.blackColor().CGColor
        self.layer.mask = layer
        return layer
    }
}
