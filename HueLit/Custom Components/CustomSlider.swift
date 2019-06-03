//
//  CustomSlider.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-03.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 25
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }

}
