//
//  ImageExtensions.swift
//  DemoPureCloud
//
//  Copyright © 2021 VideoEngager. All rights reserved.
//

import UIKit


extension UIColor {
    class var AppBackgroundColor: UIColor {
        return UIColor(red: 57/255, green: 154/255, blue: 202/255, alpha: 1)
    }
    
    class var regularTextColor: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }

}


extension UIImageView {

    func setRoundedImage(cornerRadius: CGFloat, border: Bool) {
        if (border) {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 0.2).cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

}


extension CALayer {
    
    // MARK: Usage - imageView.layer.applyRoundCornerMaskWith(radius: 5)
    func applyRoundCornerMaskForAllCornersWith(radius: CGFloat) {
        let path:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds,
                                                  cornerRadius: radius)
        let layer = CAShapeLayer.init()
        layer.path = path.cgPath
        layer.frame = self.bounds
        self.mask = layer
    }
    
    // MARK: Usage - imageView.layer.applyRoundCornerMaskWith(radius: 5, corners: [.topRight, .bottomLeft])
    func applyRoundCornerMaskForSelectedCornersWith(radius: CGFloat, corners: UIRectCorner) {
        let path:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds,
                                                  byRoundingCorners: corners,
                                                  cornerRadii: CGSize(width: radius,
                                                                      height: radius))
        let layer = CAShapeLayer.init()
        layer.path = path.cgPath
        layer.frame = self.bounds
        self.mask = layer
    }
    
}


class Pulsing: CALayer {
    
    var animationGroup = CAAnimationGroup()
    
    var initialPulseScale:Float = 0
    var nextPulseAfter:TimeInterval = 0
    var animationDuration:TimeInterval = 1.5
    var radius:CGFloat = 200
    var numberOfPulses:Float = Float.infinity
    
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init (numberOfPulses:Float = Float.infinity, radius:CGFloat, position:CGPoint) {
        super.init()
        
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
        
        
        
    }
    
    
    func createScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
        
        
    }
    
    
    
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}



extension String {
    func canOpenUrl() -> Bool {
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: self)
    }
}
    
    
