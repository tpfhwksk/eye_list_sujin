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

class TableViewCell_UIView: UIView {

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
    
    func loadPanoramaView(image: String) {
        #if arch(arm) || arch(arm64)
            let panoramaView = PanoramaView(frame: self.bounds, device: device)
        #else
            let panoramaView = PanoramaView(frame: self.bounds) // iOS Simulator
        #endif
        panoramaView.setNeedsResetRotation()
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
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
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: panoramaView, action: #selector(PanoramaView.setNeedsResetRotation(_:)))
        
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        panoramaView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        
        //
       // panoramaView.addGestureRecognizer(setGestureRecognizer())
        //
        
        self.panoramaView = panoramaView
        // modify
        /*
        var motionManager = CMMotionManager()
        guard motionManager.isDeviceMotionAvailable else {return}
        motionManager.deviceMotionUpdateInterval = 0.015
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: OperationQueue.main, withHandler: {[weak self] (motionData, error) in
            guard let panoramaView = self else {return}
            
            let motionData = motionData
            
            let rm = motionData?.attitude.rotationMatrix
            var userHeading = .pi - atan2((rm?.m32)!, (rm?.m31)!)
            userHeading += .pi/2
            
            
                // Use quaternions when in spherical mode to prevent gimbal lock
            panoramaView.cameraNode.orientation = motionData.orientation()
        
            panoramaView.reportMovement(CGFloat(userHeading), panoramaView.xFov.toRadians())
        })
        */
        // ---*---
        
        let resizeimage = ResizeImage(image: UIImage(named: image)!, targetSize: CGSize(100.0, 60.0))
        //didn't work
        
        //panoramaView.load(UIImage(named: image)!, format: .mono)
        panoramaView.load(resizeimage, format: .mono)

    }
   

}
