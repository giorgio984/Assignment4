//
//  DetailsViewController.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 10/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, DetailsViewDelegate {
    func loadComics(description: ([Comic])) {
        comicsList = description
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private let comicPresenter = ComicPresenter(marvelService: MarvelService())
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var descriptionList:[String] = []
    var comicsList = [] as [Comic]
    
    var name: String? = ""
    var descriptionC: String? = ""
    var avatarURL: URL!
    var comicsURL: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        self.tableView.rowHeight = 150.0
        avatar.loadImge(withUrl: avatarURL)
        if (descriptionC ?? "").isEmpty {
            descriptionC = "Nessuna descrizione disponibile."
        }
        descriptionList.append(descriptionC!)
        
        comicPresenter.setViewDelegate(detailViewDelegate: self)
        comicPresenter.allComics(comicsUrl: comicsURL)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(segControl.selectedSegmentIndex) {
        case 0:
            returnValue = descriptionList.count
            break
        case 1:
            returnValue = comicsList.count
            break
        default:
            break
            
        }
        
        return returnValue
        
    }
       
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch(segControl.selectedSegmentIndex) {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ComicDescriptionCell
                cell.comicDescription.text = descriptionList[indexPath.row]
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath) as! ComicTableViewCell
                cell.comicTitle.text = comicsList[indexPath.row].title
                let imageUrl:URL = URL(string: comicsList[indexPath.row].thumbnail)!
                cell.comicImg.loadImge(withUrl: imageUrl)
                cell.comicPrice.text = comicsList[indexPath.row].prices
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel!.text = ""
                return cell
       }
        
       
        
    }

    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
       tableView.reloadData()
    }
    
    
    
    
}


class ComicTableViewCell: UITableViewCell {
    @IBOutlet weak var comicImg: UIImageView!
    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicPrice: UILabel!
    
    
}

class ComicDescriptionCell: UITableViewCell {
    @IBOutlet weak var comicDescription: UITextView!
    
}
