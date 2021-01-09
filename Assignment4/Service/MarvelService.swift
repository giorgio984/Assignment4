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
    static let pukey = "XXXXXXXXXXXXXXXXXXX"
    static let prkey = "XXXXXXXXXXXXXXXXXXX"
    static let ts =  NSDate().timeIntervalSince1970
}

class MarvelService {
    
    func getCharacters_(callBack:([Character]) -> Void) {
        // Test
        let charactersList = [Character(name: "Name 1", description: "http://mobile.aws.skylabs.it/mobileassignments/marvel/placeholder.png"),
                             Character(name: "Name 2", description: "http://mobile.aws.skylabs.it/mobileassignments/marvel/placeholder.png"),
                             Character(name: "Name 3", description: "http://mobile.aws.skylabs.it/mobileassignments/marvel/placeholder.png")
        ]
        callBack(charactersList)
    }
    
    
    
    func getCharacters(callBack:([Character]) -> Void) {
        // valore TimeStamp
        let timeS = String(format: "%f", konstants.ts)
        
        guard var components = URLComponents(string: konstants.baseURL) else {
                print("Error: cannot create URLCompontents")
                return
            }
            components.queryItems = [
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
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }
    
}
