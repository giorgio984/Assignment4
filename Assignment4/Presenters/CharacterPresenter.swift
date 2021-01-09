//
//  CharacterPresenter.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 09/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import Foundation

protocol ListaTableViewDelegate: NSObjectProtocol {
    func loadCharacter(description:([Character]))
}

class CharacterPresenter {
    private let marvelService:MarvelService
    weak private var listaTableViewDelegate : ListaTableViewDelegate?
    
    init(marvelService:MarvelService){
        self.marvelService = marvelService
    }
    
    func setViewDelegate(listaTableViewDelegate:ListaTableViewDelegate?){
        self.listaTableViewDelegate = listaTableViewDelegate
    }
    
    func allCharacters(){
        
        marvelService.getCharacters() { [weak self] charactersList in
                self?.listaTableViewDelegate?.loadCharacter(description: charactersList)
        }
        
    }
}
