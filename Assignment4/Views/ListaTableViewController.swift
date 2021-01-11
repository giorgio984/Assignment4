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
        characters.append(contentsOf: description)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var characterLista: UITableView!
    @IBOutlet weak var orderButton: UIBarButtonItem!
    
    private let characterPresenter = CharacterPresenter(marvelService: MarvelService())
    
    var characters = [] as [Character]
    var selected:Character? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 100.0
        self.title = "Lista"
        self.searchBar.delegate = self
        
        // SETTO IL VALORE INIZIALE DEL BUTTONITEM
        let userDefaults = UserDefaults.standard
        if let orderName = userDefaults.value(forKey: "orderName") {
            if (orderName as! String == "name"){
                orderButton.title = "ASC"
            }
            else{
                orderButton.title = "DESC"
            }
        }
        else {
            orderButton.title = "ASC"
        }
        
        characterPresenter.setViewDelegate(listaTableViewDelegate: self)
        characterPresenter.allCharacters(paginationIndex: 0, searchName: "")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListaCell", for: indexPath) as! ListaTableViewCell
        
        // fix per overlap durante lo scroll
        cell.avatar.image = nil
        
        let character = characters[indexPath.row]
        cell.characterName?.text = character.name
        let imageUrl:URL = URL(string: character.thumbnail)!
        cell.avatar.loadImge(withUrl: imageUrl)
            
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let character = characters[indexPath.row]
        selected = character
        performSegue(withIdentifier: "detailsVC", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchBar.searchTextField.endEditing(true)
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == characters.count-5 {
            characterPresenter.allCharacters(paginationIndex: characters.count, searchName: "" )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsVC" {
            let DestViewController = segue.destination as! DetailsViewController
            DestViewController.name = selected?.name
            DestViewController.descriptionC = selected?.description
            DestViewController.avatarURL = URL(string: selected!.thumbnail)!
            DestViewController.comicsURL = selected!.comicsURL
        }
    }
    
    
    @IBAction func changeOrder(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if let orderName = userDefaults.value(forKey: "orderName") {
            
            if (orderName as! String == "name"){
                orderButton.title = "DESC"
                userDefaults.setValue("-name", forKey: "orderName")
            }
            else{
                orderButton.title = "ASC"
                userDefaults.setValue("name", forKey: "orderName")
            }
            userDefaults.synchronize()
        }
        else {
            userDefaults.setValue("name", forKey: "orderName")
            userDefaults.synchronize()
        }
        characters = []
        characterPresenter.allCharacters(paginationIndex: 0, searchName: "")
    }
    
    
}

extension ListaTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cerco solo quando il nome è maggiore di 2 caratteri
        if searchText.count > 2{
            characters = []
            characterPresenter.allCharacters(paginationIndex: 0, searchName: searchText )
            
            // PRECEDENTE IMPLEMENTAZIONE DI RICERCA, CERCA SOLO SU QUELLO CHE È STATO CARICATO IN TABELLA
            //searchedCharacter = characters.filter{$0.name.range(of: searchText, options: [.anchored, .caseInsensitive]) != nil }
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        characters = []
        characterPresenter.allCharacters(paginationIndex: 0, searchName: "")
    }
}
