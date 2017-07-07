//
//  ImageLoadable.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import SceneKit
import UIKit

public protocol ImageLoadable {
    func load(_ image: UIImage, format: MediaFormat)
}

extension ImageLoadable where Self: SceneLoadable {
    public func load(_ image: UIImage, format: MediaFormat) {
        scene = ImageSceneLoader().load(image, format: format)
    }
}

public struct ImageSceneLoader {
    public init() {}
    
    public func load(_ image: UIImage, format: MediaFormat) -> SCNScene {
        let scene: ImageScene
        
        switch format {
        case .mono:
            scene = MonoSphericalImageScene()
        case .stereoOverUnder:
            scene = StereoSphericalImageScene()
        }
        
        scene.image = image
        
        return scene as! SCNScene
    }
}
