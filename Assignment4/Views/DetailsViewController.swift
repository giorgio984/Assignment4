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
        self.tableView.rowHeight = 100.0
        avatar.loadImge(withUrl: avatarURL)
        descriptionList.append(descriptionC!)
        print(descriptionC ?? "-desc-")
        print(comicsURL ?? "-url-")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch(segControl.selectedSegmentIndex) {
        case 0:
            cell.textLabel!.text = descriptionList[indexPath.row]
            break
        case 1:
            cell.textLabel!.text = comicsList[indexPath.row].title
            break
        default:
            break
       }
        
       return cell
        
    }

    @IBAction func segmentedControlActionChanged(sender: AnyObject) {

       tableView.reloadData()
    }
    
    
    
    
}
