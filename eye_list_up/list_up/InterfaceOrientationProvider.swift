//
//  InterfaceOrientationProvider.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit

public protocol InterfaceOrientationProvider {
    func interfaceOrientation(atTime time: TimeInterval) -> Rotation?
}

extension UIInterfaceOrientation: InterfaceOrientationProvider {
    public func interfaceOrientation(atTime time: TimeInterval) -> Rotation? {
        var rotation = Rotation()
        
        switch self {
        case .portraitUpsideDown:
            rotation.rotate(byZ: .pi)
        case .landscapeLeft:
            rotation.rotate(byZ: .pi / 2)
        case .landscapeRight:
            rotation.rotate(byZ: .pi / -2)
        default:
            break
        }
        
        return rotation
    }
}

extension UIApplication: InterfaceOrientationProvider {
    public func interfaceOrientation(atTime time: TimeInterval) -> Rotation? {
        return statusBarOrientation.interfaceOrientation(atTime: time)
    }
}

internal final class DefaultInterfaceOrientationProvider: InterfaceOrientationProvider {
    func interfaceOrientation(atTime time: TimeInterval) -> Rotation? {
        return UIApplication.shared.interfaceOrientation(atTime: time)
    }
}
