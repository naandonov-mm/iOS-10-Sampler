//
//  ViewController.swift
//  UIViewPropertyAnimatorSwiftSample
//
//  Created by nikolay.andonov on 10/3/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit

class PropertyAnimatorViewController: UIViewController {

    private var targetLocation: CGPoint!
    private var animator : UIViewPropertyAnimator?
    
    @IBOutlet weak var objectView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objectView.backgroundColor = colorAt(location: objectView.center)
        targetLocation = objectView.center
    }

    // MARK: - Utilities
    
    private func colorAt(location: CGPoint) -> UIColor {
        
        let hue: CGFloat = (location.x / UIScreen.main.bounds.width + location.y / UIScreen.main.bounds.height) / 2
        return UIColor(hue: hue, saturation: 0.78, brightness: 0.75, alpha: 1)
    }
    
    private func processTouches(_ touches: Set<UITouch>) {
        
        guard let touch = touches.first else {return}
        let loc = touch.location(in: view)
        
        if loc == targetLocation {
            return
        }
        
        animateTo(location: loc)
    }
    
    private func animateTo(location: CGPoint) {
        
        let duration: TimeInterval = 0.6
        let timing: UITimingCurveProvider = UISpringTimingParameters(dampingRatio: 0.5)
        
        animator = UIViewPropertyAnimator(
            duration: duration,
            timingParameters: timing)
        
        weak var weakSelf = self
        animator = UIViewPropertyAnimator.init(duration: duration, dampingRatio: 0.5, animations: { 
            
            weakSelf?.objectView.center = location
            weakSelf?.objectView.backgroundColor = self.colorAt(location: location)
        })
        
        animator?.startAnimation()
        targetLocation = location
    }
    
    
    // MARK: - Touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        processTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        processTouches(touches)
    }

}

