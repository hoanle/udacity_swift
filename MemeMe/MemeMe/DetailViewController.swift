//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Hoan on 20/3/18.
//  Copyright © 2018 Hoan. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.done, target: self, action: #selector(onEdit))
        image.image = meme?.memeImage
    }
    
    @objc func onEdit() {
        let editVC = self.storyboard!.instantiateViewController(withIdentifier: "mememeShareVC") as! ViewController
        editVC.currentMeme = meme
        editVC.canGoBack = true
        self.present(editVC, animated: true)
    }
}
