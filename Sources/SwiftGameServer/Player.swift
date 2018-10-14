//
//  User.swift
//  COpenSSL
//
//  Created by Karl Petersson on 2018-09-16.
//

import Foundation

class Player:Hashable {
    let id:String
    
    init(id:String) {
        self.id = id
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Position: Encodable, Decodable{
    let x: Int
    let y: Int
}
