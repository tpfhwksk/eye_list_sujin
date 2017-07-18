//
//  testViewController.swift
//  list_up
//
//  Created by eliza on 2017-07-17.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testimageview.image = ResizeImage(image: UIImage(named: "pano01")!, targetSize: CGSize(300.0, 300.0))
        
        //testimageview.image = UIImage(named: "pano01")!
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var testimageview: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
