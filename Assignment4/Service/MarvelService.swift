//
//  MarvelService.swift
//  Assignment4
//
//  Created by MacBook Giorgio on 09/01/2021.
//  Copyright © 2021 GM. All rights reserved.
//

import Foundation
import CryptoKit

extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}



struct konstants{
    static let baseURL = "https://gateway.marvel.com:443/v1/public/characters"
    static let pukey = "dac9ba2cbe5cdeb42e12a957603110a6"
    static let prkey = "7f6cd5de17ec10bd3dd1ef237e4b54d454ddb009"
    static let ts =  NSDate().timeIntervalSince1970
    
    static let limit = "50"
    static let placeholder = "http://mobile.aws.skylabs.it/mobileassignments/marvel/placeholder.png"
}


class MarvelService {
    
    func getCharacters(callBack: @escaping([Character]) -> Void) {
        // valore TimeStamp, lo converto in string
        let timeS = String(format: "%f", konstants.ts)
        
        guard var components = URLComponents(string: konstants.baseURL) else {
                print("Error: cannot create URLCompontents")
                return
            }
        components.queryItems = [
            URLQueryItem(name: "limit", value: konstants.limit),
            URLQueryItem(name: "ts", value: timeS),
            URLQueryItem(name: "apikey", value: konstants.pukey),
            URLQueryItem(name: "hash", value: (timeS+konstants.prkey+konstants.pukey).MD5) // md5(ts+privateKey+publicKey)
        ]
        guard let url = components.url else {
            print("Error: cannot create URL")
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print(request)
                return
            }
            
            
            do{
                var characters = [Character]()
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonResponse as? [String: Any] {
                    
                    let dataJson = dictionary["data"] as? [String: Any]
                    let dd = dataJson!["results"]as? [[String: Any]]
                    dd!.forEach {
                        let thumbnail = $0["thumbnail"] as? [String: Any]
                        let path = thumbnail?["path"] as? String
                        let ext = thumbnail?["extension"] as? String
                        var avatar = path! + "." + ext!
                        
                        let comicsInfo = $0["comics"] as? [String: Any]
                        let comics = comicsInfo?["collectionURI"] as? String
                        
                        // Se non esiste l'immagine allora uso placeholder
                        if avatar.contains("image_not_available") {
                            avatar = konstants.placeholder
                        }
                        // creo l'array di supereroi marvel
                        characters.append(Character.init(name: $0["name"] as! String, thumbnail: avatar, description: $0["description"] as! String, comicsURL: comics!) )
                    }
                }
                
                // Lo passo alla tableview
                callBack(characters)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            
            
        }.resume()
    }
    
    func getComics(comicsURL: String, callBack: @escaping([Comic])-> Void) {
        // valore TimeStamp, lo converto in string
        let timeS = String(format: "%f", konstants.ts)
        
        guard var components = URLComponents(string: comicsURL) else {
                print("Error: cannot create URLCompontents")
                return
            }
        components.queryItems = [
            URLQueryItem(name: "limit", value: konstants.limit),
            URLQueryItem(name: "ts", value: timeS),
            URLQueryItem(name: "apikey", value: konstants.pukey),
            URLQueryItem(name: "hash", value: (timeS+konstants.prkey+konstants.pukey).MD5) // md5(ts+privateKey+publicKey)
        ]
        guard let url = components.url else {
            print("Error: cannot create URL")
            return
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print(request)
                return
            }
            
            do{
                var comics = [Comic]()
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonResponse as? [String: Any] {
                    
                    
                    let dataJson = dictionary["data"] as? [String: Any]
                    let dd = dataJson!["results"]as? [[String: Any]]
                    dd!.forEach {
                        let thumb = $0["thumbnail"] as? [String: Any]
                        let path = thumb?["path"] as? String
                        let ext = thumb?["extension"] as? String
                        var thumbnail = path! + "." + ext!
                        // Se non esiste l'immagine allora uso placeholder
                        if thumbnail.contains("image_not_available") {
                            thumbnail = konstants.placeholder
                        }
                        
                        //let pri = $0["prices"] as? [String: Any]
                        //print(pri)
                        print(thumbnail)
                        print($0["title"] as! String)
                        //print($0["description"] as! String)
                        
                        // creo l'array con le info sui Comics
                        comics.append(Comic.init(title: $0["title"] as! String, thumbnail: thumbnail, description: "--", pageCount: $0["pageCount"] as! Int, prices: "-"))
                    }
                    
                }
                
                // Lo passo alla tableview
                callBack(comics)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
            
            
        }.resume()
    }
    
}
