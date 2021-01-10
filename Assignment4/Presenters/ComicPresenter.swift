//
//  ComicPresenter.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 10/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import Foundation

protocol DetailsViewDelegate: NSObjectProtocol {
    func loadComics(description:([Comic]))
}

class ComicPresenter {
    private let marvelService:MarvelService
    weak private var detailViewDelegate : DetailsViewDelegate?
    
    init(marvelService:MarvelService){
        self.marvelService = marvelService
    }
    
    func setViewDelegate(detailViewDelegate:DetailsViewDelegate?){
        self.detailViewDelegate = detailViewDelegate
    }
    
    func allComics(comicsUrl : String){
        
        marvelService.getComics(comicsURL: comicsUrl){ [weak self] charactersList in
            self?.detailViewDelegate?.loadComics(description: charactersList)
        }
        
    }
    
    
}
