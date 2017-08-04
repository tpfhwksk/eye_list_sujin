//
//  TableViewCell_UIView.swift
//  list_up
//
//  Created by eyexpo on 2017-07-07.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit
import Metal
import CoreMotion

class TableViewCellUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var image_name:String = ""
    
    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create MTLDevice")
        }
        return device
    }()
    
    weak var panoramaView: PanoramaView?
    
    func loadPanoramaView(image: String, compressQuality: Float = 1.0) {
        #if arch(arm) || arch(arm64)
            let panoramaView = PanoramaView(frame: self.bounds, device: device)
        #else
            let panoramaView = PanoramaView(frame: self.bounds) // iOS Simulator
        #endif
        panoramaView.setNeedsResetRotation()
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        panoramaView.testing = image
        self.addSubview(panoramaView)
        
        // fill parent view
        let constraints: [NSLayoutConstraint] = [
            panoramaView.topAnchor.constraint(equalTo: self.topAnchor),
            panoramaView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            panoramaView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            panoramaView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        // double tap to reset rotation
        /*
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: panoramaView, action: #selector(PanoramaView.setNeedsResetRotation(_:)))
 
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        panoramaView.addGestureRecognizer(doubleTapGestureRecognizer)
        */
        
        self.panoramaView = panoramaView
            
        //let resizeimage = UIImage(named: image)!.resizeWithPercent(percentage: 0.1)

        let originImage = UIImage(named: image)!
        
        let compressData = UIImageJPEGRepresentation(originImage, CGFloat(compressQuality)) //max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData!)
        panoramaView.load(compressedImage!, format: .mono)
        
    }

}
