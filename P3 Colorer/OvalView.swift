//
//  OvalView.swift
//  P3 Colorer
//
//  Created by Monica Ong on 12/30/15.
//  Copyright © 2015 Monica Ong. All rights reserved.
//

import UIKit

class OvalView: UIView {
    

//    // Only override drawRect: if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//        
//        //Mask
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = CGPathCreateWithEllipseInRect(self.bounds, nil)
//        self.layer.mask = shapeLayer
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutOvalMask()
    }
    
    private func layoutOvalMask() {
        let mask = self.shapeMaskLayer()
        let bounds = self.bounds
        if mask.frame != bounds {
            mask.frame = bounds
            mask.path = CGPathCreateWithEllipseInRect(bounds, nil)
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
