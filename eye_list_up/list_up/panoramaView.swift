//
//  panoramaView.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit
import SceneKit

var cnt: Int = 0

public class PanoramaView: UIView, SceneLoadable {
    #if (arch(arm) || arch(arm64)) && os(iOS)
    public let device: MTLDevice
    #endif
    
    var testing: String = ""
    
    public var scene: SCNScene? {
        get {
            return scnView.scene
        }
        set(value) {
            orientationNode.removeFromParentNode()
            value?.rootNode.addChildNode(orientationNode)
            scnView.scene = value
        }
    }
    
    public weak var sceneRendererDelegate: SCNSceneRendererDelegate?
    
    
    /*
    public lazy var orientationNode: OrientationNode = {
        let node = OrientationNode()
        let mask = CategoryBitMask.all.subtracting(.rightEye)
        node.pointOfView.camera?.categoryBitMask = mask.rawValue
        return node
    }()
 */
 
 
 
    lazy var scnView: SCNView = {
        #if (arch(arm) || arch(arm64)) && os(iOS)
            let view = SCNView(frame: self.bounds, options: [
                SCNView.Option.preferredRenderingAPI.rawValue: SCNRenderingAPI.metal.rawValue,
                SCNView.Option.preferredDevice.rawValue: self.device
                ])
        #else
            let view = SCNView(frame: self.bounds)
        #endif
        view.backgroundColor = .black
        view.isUserInteractionEnabled = false
        view.delegate = self
        view.pointOfView = orientationNode.pointOfView
        view.isPlaying = true
        self.addSubview(view)
        return view
    }()
    
    
    // to integrated panGesture
    
    
    fileprivate lazy var panGestureManager: PanoramaPanGestureManager = {
        let manager = PanoramaPanGestureManager(rotationNode: orientationNode.userRotationNode)
        manager.minimumVerticalRotationAngle = -60 / 180 * .pi
        manager.maximumVerticalRotationAngle = 60 / 180 * .pi
        return manager
    }()
 
    /*
    
    fileprivate lazy var interfaceOrientationUpdater: InterfaceOrientationUpdater = {
        return InterfaceOrientationUpdater(orientationNode: orientationNode)
    }()
    
    */
    
    #if (arch(arm) || arch(arm64)) && os(iOS)
    public init(frame: CGRect, device: MTLDevice) {
    self.device = device
    super.init(frame: frame)
    addGestureRecognizer(panGestureManager.gestureRecognizer) // modify
    
    }
    #else
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(panGestureManager.gestureRecognizer) // modify
    }
    #endif
 
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        orientationNode.removeFromParentNode()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        scnView.frame = bounds
    }
    
    
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            interfaceOrientationUpdater.stopAutomaticInterfaceOrientationUpdates()
        } else {
           // print("willmover") is called once.
            interfaceOrientationUpdater.startAutomaticInterfaceOrientationUpdates()
            interfaceOrientationUpdater.updateInterfaceOrientation()
        }
    }
    
}

extension PanoramaView: ImageLoadable {}

#if (arch(arm) || arch(arm64)) && os(iOS)
    extension PanoramaView: VideoLoadable {}
#endif

extension PanoramaView {
    public var sceneRenderer: SCNSceneRenderer {
        return scnView
    }
    
    public var isPlaying: Bool {
        get {
            return scnView.isPlaying
        }
        set(value) {
            scnView.isPlaying = value
        }
    }
    
    public var antialiasingMode: SCNAntialiasingMode {
        get {
            return scnView.antialiasingMode
        }
        set(value) {
            scnView.antialiasingMode = value
        }
    }
    
    public func snapshot() -> UIImage {
        return scnView.snapshot()
    }
    
    
    public var panGestureRecognizer: UIPanGestureRecognizer {
   
        return panGestureManager.gestureRecognizer
    }
    
    /* ref for all interfaceorientation
    
    public func updateInterfaceOrientation() {
        interfaceOrientationUpdater.updateInterfaceOrientation()
    }
 
    
    public func updateInterfaceOrientation(with transitionCoordinator: UIViewControllerTransitionCoordinator) {
        interfaceOrientationUpdater.updateInterfaceOrientation(with: transitionCoordinator)
    }
 
 
    
    public func setNeedsResetRotation(animated: Bool = false) {
        panGestureManager.stopAnimations()
        //setGestureRecognizer().stopAni
        orientationNode.setNeedsResetRotation(animated: animated)
    }
    
    public func setNeedsResetRotation(_ sender: Any?) {
        setNeedsResetRotation(animated: true)
    }
 */
    func setNeedsResetRotation(animated: Bool = false) {
        panGestureManager.stopAnimations()
        orientationNode.setNeedsResetRotation(animated: animated)
    }
}

extension PanoramaView: OrientationIndicatorDataSource {
    public var pointOfView: SCNNode? {
        return orientationNode.pointOfView
    }
    
    public var viewportSize: CGSize {
        return scnView.bounds.size
    }
}


// make one paranomaView as paranomaView_detail.
extension PanoramaView: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        var disableActions = false
        
        if let provider = orientationNode.deviceOrientationProvider, provider.shouldWaitDeviceOrientation(atTime: time) {
            provider.waitDeviceOrientation(atTime: time)
            disableActions = false
        }
        
        //  why is this necessary?
        
        
        SCNTransaction.lock()
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1 / 15
        //SCNTransaction.animationDuration = 1
        //print("scnscenerenderedelegate") // called every second

        SCNTransaction.disableActions = disableActions
    
        orientationNode.updateDeviceOrientation(atTime: time) // ###^$#&##^#@^@ very very important
        
        
        
        SCNTransaction.commit()
        SCNTransaction.unlock()
 
        
        sceneRendererDelegate?.renderer?(renderer, updateAtTime: time)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        sceneRendererDelegate?.renderer?(renderer, didApplyAnimationsAtTime: time)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        sceneRendererDelegate?.renderer?(renderer, didSimulatePhysicsAtTime: time)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        sceneRendererDelegate?.renderer?(renderer, willRenderScene: scene, atTime: time)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        sceneRendererDelegate?.renderer?(renderer, didRenderScene: scene, atTime: time)
    }
}
