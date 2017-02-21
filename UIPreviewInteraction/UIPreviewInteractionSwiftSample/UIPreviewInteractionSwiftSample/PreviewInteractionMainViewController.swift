//
//  PreviewInteractionMainViewController.swift
//  UIPreviewInteractionSwiftSample
//
//  Created by nikolay.andonov on 10/17/16.
//  Copyright © 2016 nikolay.andonov. All rights reserved.
//

import UIKit

class PreviewInteractionMainViewController: UIViewController, UIPreviewInteractionDelegate {

    private var previewInteraction: UIPreviewInteraction!
    weak private var popViewController: PreviewInteractionPopViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewInteraction = UIPreviewInteraction(view: view)
        previewInteraction.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewController = segue.destination as? PreviewInteractionPopViewController {
            popViewController = viewController
        }
    }

    // MARK: - UIPreviewInteractionDelegate

    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
        
        if popViewController == nil {
            performSegue(withIdentifier: "InteractionSegue", sender: nil)
        }
        guard let popViewController = popViewController else {fatalError()}
        popViewController.progressLabel.text = String(format: "%.0f%", transitionProgress * 100)
        
        if ended {
            popViewController.statusLabel.text = "Peek!"
        }
    }
    
    func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdateCommitTransition transitionProgress: CGFloat, ended: Bool) {
        
        guard let popViewController = popViewController else {fatalError()}
        popViewController.animator.fractionComplete = transitionProgress
        popViewController.progressLabel.text = String(format: "%.0f%", transitionProgress * 100)
        if ended {
            popViewController.statusLabel.text = "Pop!"
        }
    }
    
    func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
        dismiss(animated: true) {
            self.popViewController?.statusLabel.text = ""
        }
    }
}
