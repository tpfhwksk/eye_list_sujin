//
//  Rotation+CoreMotion.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import GLKit
import CoreMotion

extension Rotation {
    public init(_ cmQuaternion: CMQuaternion) {
        self.init(GLKQuaternionMake(
            Float(cmQuaternion.x),
            Float(cmQuaternion.y),
            Float(cmQuaternion.z),
            Float(cmQuaternion.w)
        ))
    }
    
    public init(_ cmAttitude: CMAttitude) {
        self.init(cmAttitude.quaternion)
    }
    
    public init(_ cmDeviceMotion: CMDeviceMotion) {
        self.init(cmDeviceMotion.attitude)
    }
}
