//
//  ImageExtensions.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit

extension UIImageView {

    func setRoundedImage(cornerRadius: CGFloat, border: Bool) {
        if (border) {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 0.2).cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
        // self.layer.cornerRadius = HCP_ICON_WIDTH / 2
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        // self.layer.applyRoundCornerMaskForAllCornersWith(radius: cornerRadius)
        
    }

}
    
    
