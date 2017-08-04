//
//  detail_ViewController.swift
//  list_up
//
//  Created by eyexpo on 2017-07-07.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit
import Metal

class detailViewController: UIViewController {
    
    var image_name:String = ""

    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create MTLDevice")
        }
        return device
    }()
    
    weak var panoramaView: PanoramaViewDetail?
    
    private func loadPanoramaView() {
        #if arch(arm) || arch(arm64)
            let panoramaView = PanoramaViewDetail(frame: view.bounds, device: device)
        #else
            let panoramaView = PanoramaViewDetail(frame: view.bounds) // iOS Simulator
        #endif
        panoramaView.setNeedsResetRotation()
        //setNeedsResetRotation()
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panoramaView)
        
        // fill parent view
        let constraints: [NSLayoutConstraint] = [
            panoramaView.topAnchor.constraint(equalTo: view.topAnchor),
            panoramaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panoramaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panoramaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        // double tap to reset rotation
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: panoramaView, action: #selector(PanoramaViewDetail.setNeedsResetRotation(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        panoramaView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        self.panoramaView = panoramaView
        
        panoramaView.load(UIImage(named: image_name)!, format: .mono)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPanoramaView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        panoramaView?.updateInterfaceOrientation(with: coordinator)
    }

}
