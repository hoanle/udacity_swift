//
//  TableViewController.swift
//  MemeMe
//
//  Created by Hoan on 19/3/18.
//  Copyright © 2018 Hoan. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController  {
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mememeShareVC") as! ViewController
        VC1.canGoBack = true
        self.present(VC1, animated:true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")!
        let meme = self.memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memeImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "detailController") as! DetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        memes = TabBarViewController.memes
        self.tableView.reloadData()
    }
}
