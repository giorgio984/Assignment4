//
//  GrigliaCollectionViewController.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 10/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import UIKit

class GrigliaCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
}

class GrigliaCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "grigliaCell"
    var testA = ["uno", "due", "tre", "quattro"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testA.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grigliaCell", for: indexPath) as! GrigliaCollectionViewCell
        cell.characterName.text = testA[indexPath.row]
        return cell
    }
}
