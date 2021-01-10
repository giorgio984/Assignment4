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

class GrigliaCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, GrigliaCollectionDelegate {
    func loadCharacter(description: ([Character])) {
        characters = description
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private let reuseIdentifier = "grigliaCell"
    
    private let characterPresenter = CharacterPresenter(marvelService: MarvelService())
    
    var characters = [] as [Character]
    var selected:Character? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        characterPresenter.setViewDelegatee(grigliaCollectionDelegate: self)
        characterPresenter.allCharactersColle()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grigliaCell", for: indexPath) as! GrigliaCollectionViewCell
        
        let character = characters[indexPath.row]
        cell.characterName?.text = character.name
        let imageUrl:URL = URL(string: character.thumbnail)!
        cell.avatar.loadImge(withUrl: imageUrl)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let character = characters[indexPath.row]
        selected = character
        
        performSegue(withIdentifier: "detailCVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCVC" {
            let DestViewController = segue.destination as! DetailsViewController
            DestViewController.name = selected?.name
            DestViewController.descriptionC = selected?.description
            DestViewController.avatarURL = URL(string: selected!.thumbnail)!
            DestViewController.comicsURL = selected!.comicsURL
        }
    }
    
}
