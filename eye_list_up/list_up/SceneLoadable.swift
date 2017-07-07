//
//  SceneLoadable.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import SceneKit

public protocol SceneLoadable: class {
    var scene: SCNScene? { get set }
}
