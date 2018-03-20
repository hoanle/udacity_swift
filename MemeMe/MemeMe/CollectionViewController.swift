//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Hoan on 19/3/18.
//  Copyright © 2018 Hoan. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {
    var memes = [Meme]()
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mememeShareVC") as! ViewController
        VC1.canGoBack = true
        self.present(VC1, animated:true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.image.image = meme.memeImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "detailController") as! DetailViewController
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        memes = TabBarViewController.memes
        self.collectionView?.reloadData()
    }
}
