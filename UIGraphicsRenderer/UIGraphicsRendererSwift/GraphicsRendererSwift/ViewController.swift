//
//  ViewController.swift
//  GraphicsRendererSwift
//
//  Created by Dobrinka Tabakova on 12/9/16.
//  Copyright © 2016 Dobrinka Tabakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DispatchQueue.global(qos: .default).async {
            let pdfData = UIGraphicsPDFRenderer(bounds: self.view.bounds).pdfData(actions: { (rendererContext) in
                let pageCount = 500
                let image = UIImage(named: "black-cat.jpg")
                let pdfPageBounds = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
                for _ in 0..<pageCount {
                    rendererContext.beginPage(withBounds: pdfPageBounds, pageInfo: [:]);
                    image?.draw(in: pdfPageBounds)
                }
            })
            DispatchQueue.main.async(execute: {
                self.webView.load(pdfData, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL() as URL)
                self.activityIndicator.stopAnimating()
                self.webView.isHidden = false
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

