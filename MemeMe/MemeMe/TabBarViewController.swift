
//
//  TabBarViewController.swift
//  MemeMe
//
//  Created by Hoan on 19/3/18.
//  Copyright © 2018 Hoan. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    static var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if TabBarViewController.memes.count == 0 {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mememeShareVC") as! ViewController
            self.present(VC1, animated:true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
}
