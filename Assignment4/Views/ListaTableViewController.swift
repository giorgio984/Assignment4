//
//  ListaTableViewController.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 08/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import UIKit

extension UIImageView {
    func loadImge(withUrl url: URL) {
           DispatchQueue.global().async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}

class ListaTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
}

class ListaTableViewController: UITableViewController, ListaTableViewDelegate {
    func loadCharacter(description: ([Character])) {
        characters = description
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var characterLista: UITableView!
    
    private let characterPresenter = CharacterPresenter(marvelService: MarvelService())
    
    var searching = false
    var searchedCharacter:[Character] = []
    
    var characters = [] as [Character]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 100.0

        self.searchBar.delegate = self
        
        characterPresenter.setViewDelegate(listaTableViewDelegate: self)
        characterPresenter.allCharacters()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {
            return searchedCharacter.count
        } else {
            return characters.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaCell", for: indexPath) as! ListaTableViewCell
        
        if searching {
            let character = searchedCharacter[indexPath.row]
            cell.characterName?.text = character.name
            let imageUrl:URL = URL(string: character.thumbnail)!
            cell.avatar.loadImge(withUrl: imageUrl)
        } else {
            let character = characters[indexPath.row]
            cell.characterName?.text = character.name
            let imageUrl:URL = URL(string: character.thumbnail)!
            cell.avatar.loadImge(withUrl: imageUrl)
            
        }
        
        return cell
    }

}

extension ListaTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCharacter = characters.filter{$0.name.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        tableView.reloadData()
    }
}
