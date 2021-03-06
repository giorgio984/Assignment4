//
//  Character.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 09/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//
import Foundation

struct Character : Decodable  {
    var name: String
    var thumbnail : String
    var description : String
    var comicsURL : String
}

struct Comic : Decodable  {
    var title: String
    var thumbnail : String
    var description : String
    var pageCount : Int
    var prices : String
}
