//
//  PreviewInteractionPopViewController.swift
//  UIPreviewInteractionSwiftSample
//
//  Created by nikolay.andonov on 10/17/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit

class PreviewInteractionPopViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var sampleImageView: UIImageView!

     internal var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressLabel.text = ""
        statusLabel.text = ""

        weak var weakSelf = self
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear) {
            weakSelf?.effectView.effect = nil
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognizerAction(recognizer:)))
        sampleImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animator.fractionComplete = 0
    }
    
    func tapGestureRecognizerAction(recognizer: UITapGestureRecognizer) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
