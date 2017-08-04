//
//  IntegratedPanGesture.swift
//  list_up
//
//  Created by eliza on 2017-07-11.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

var orientationNode: OrientationNode = {
    let node = OrientationNode()
    let mask = CategoryBitMask.all.subtracting(.rightEye)
    node.pointOfView.camera?.categoryBitMask = mask.rawValue
    return node
}()

var interfaceOrientationUpdater: InterfaceOrientationUpdater = {
    return InterfaceOrientationUpdater(orientationNode: orientationNode)
}()


func updateInterfaceOrientation() {
    interfaceOrientationUpdater.updateInterfaceOrientation()
}

func updateInterfaceOrientation(with transitionCoordinator: UIViewControllerTransitionCoordinator) {
    interfaceOrientationUpdater.updateInterfaceOrientation(with: transitionCoordinator)
}

func setNeedsResetRotation(_ sender: Any?) {
    setNeedsResetRotation(true)
}
