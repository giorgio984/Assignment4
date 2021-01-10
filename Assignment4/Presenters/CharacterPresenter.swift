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

protocol GrigliaCollectionDelegate: NSObjectProtocol {
    func loadCharacter(description:([Character]))
}

class CharacterPresenter {
    private let marvelService:MarvelService
    weak private var listaTableViewDelegate : ListaTableViewDelegate?
    weak private var grigliaCollectionDelegate : GrigliaCollectionDelegate?
    
    init(marvelService:MarvelService){
        self.marvelService = marvelService
    }
    
    func setViewDelegate(listaTableViewDelegate:ListaTableViewDelegate?){
        self.listaTableViewDelegate = listaTableViewDelegate
    }
    
    func setViewDelegatee(grigliaCollectionDelegate:GrigliaCollectionDelegate?){
        self.grigliaCollectionDelegate = grigliaCollectionDelegate
    }
    
    func allCharacters(paginationIndex : Int){
        marvelService.getCharacters(offset : paginationIndex) { [weak self] charactersList in
                self?.listaTableViewDelegate?.loadCharacter(description: charactersList)
        }
        
    }
    
    func allCharactersColle(paginationIndex : Int){
        marvelService.getCharacters(offset : paginationIndex) { [weak self] charactersList in
                self?.grigliaCollectionDelegate?.loadCharacter(description: charactersList)
        }
    }
    
}
