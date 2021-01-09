//
//  ListaTableViewController.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 08/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import UIKit

class ListaTableViewCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
}

class ListaTableViewController: UITableViewController, ListaTableViewDelegate {
    func loadCharacter(description: ([Character])) {
        characters = description
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
            cell.avatar?.image = UIImage(named: character.description)
        } else {
            let character = characters[indexPath.row]
            cell.characterName?.text = character.name
            cell.avatar?.image = UIImage(named: character.description)
        }
        
        return cell
    }

}

extension ListaTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //searchedCharacter = characters.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searchedCharacter = characters.filter{$0.name.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil }
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
