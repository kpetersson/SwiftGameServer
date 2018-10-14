//
//  Game.swift
//  ChatServer
//
//  Created by Karl Petersson on 2018-09-16.
//
import PerfectWebSockets
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation
import PerfectThread

class Game {
    private init(){}
    static var shared = Game()
    
    private var connections = [Player:WebSocket]()
    private var positions = [Player:Position]()

    func join(player:Player, socket:WebSocket) -> Void {
        connections[player] = socket
        positions[player] = Position(x: 0, y:0)
        NSLog("\(player.id ) joined")
    }
    
    func leave(player:Player) -> Void {
        connections.removeValue(forKey: player)
        positions.removeValue(forKey: player)
    }
    
    func broadcast(player: Player, message:String){
        for(player, socket) in connections {
            socket.sendStringMessage(string: message, final: true) {
                NSLog("Sending to: \(player.id) : \(message)")
            }
        }
    }
    
    func update(player: Player, position: Position){
        positions.updateValue(position, forKey: player)
    }
    
    func start(){
        Threading.dispatch {
            while true {
                NSLog("======================== STATE ========================")
                for(player, position) in self.positions {
                    NSLog("Id: \(player.id) position \(position)")
                }
                sleep(1)
            }
        }
    }
}
