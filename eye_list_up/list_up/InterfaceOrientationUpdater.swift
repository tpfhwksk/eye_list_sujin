//
//  InterfaceOrientationUpdater.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import SceneKit
import UIKit

internal final class InterfaceOrientationUpdater {
    let orientationNode: OrientationNode
    
    private var isTransitioning = false
    private var deviceOrientationDidChangeNotificationObserver: NSObjectProtocol?
    
    init(orientationNode: OrientationNode) {
        self.orientationNode = orientationNode
    }
    
    deinit {
        stopAutomaticInterfaceOrientationUpdates()
    }
    
    func updateInterfaceOrientation() {
        //print("update") once showing
        orientationNode.updateInterfaceOrientation()
    }
    
    func updateInterfaceOrientation(with transitionCoordinator: UIViewControllerTransitionCoordinator) {
        isTransitioning = true
        
        transitionCoordinator.animate(alongsideTransition: { context in
            
            
            
            SCNTransaction.lock()
            SCNTransaction.begin()
            SCNTransaction.animationDuration = context.transitionDuration
            SCNTransaction.animationTimingFunction = context.completionCurve.caMediaTimingFunction
            SCNTransaction.disableActions = !context.isAnimated
 
    
                print("updateinterfaceorientation")
            
            
            self.updateInterfaceOrientation()
            
            
            
            SCNTransaction.commit()
            SCNTransaction.unlock()
 
 
 
        }, completion: { _ in
            self.isTransitioning = false
        })
    }
    
    func startAutomaticInterfaceOrientationUpdates() {
        //this part should be started only once. 
        //now, every cell observe movement of device.
        //if movement of device occurs, we just apply this to all cell.
        
        guard deviceOrientationDidChangeNotificationObserver == nil else {
            return
        }
        
        print("move") 
        //enter O
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        let observer = NotificationCenter.default.addObserver(forName: .UIDeviceOrientationDidChange, object: nil, queue: .main) { [weak self] _ in
            guard UIDevice.current.orientation.isValidInterfaceOrientation, self?.isTransitioning == false else {
                return
            }
            //print("auto") no show
            self?.updateInterfaceOrientation()
        }
        
        deviceOrientationDidChangeNotificationObserver = observer
    }
    
    func stopAutomaticInterfaceOrientationUpdates() {
        guard let observer = deviceOrientationDidChangeNotificationObserver else {
            return
        }
        
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.removeObserver(observer)
        
        deviceOrientationDidChangeNotificationObserver = nil
    }
}

private extension UIViewAnimationCurve {
    var caMediaTimingFunction: CAMediaTimingFunction {
        let name: String
        
        switch self {
        case .easeIn:
            name = kCAMediaTimingFunctionEaseIn
        case .easeOut:
            name = kCAMediaTimingFunctionEaseOut
        case .easeInOut:
            name = kCAMediaTimingFunctionEaseInEaseOut
        case .linear:
            name = kCAMediaTimingFunctionLinear
        }
        
        return CAMediaTimingFunction(name: name)
    }
}
