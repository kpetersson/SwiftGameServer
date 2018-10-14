//
//  Handlers.swift
//  COpenSSL
//
//  Created by Karl Petersson on 2018-09-14.
//
import PerfectWebSockets
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

class GameHandler: WebSocketSessionHandler {
    let socketProtocol: String? = "game"
    var player:Player?
    
    func handleSession(request: HTTPRequest, socket: WebSocket) {
        socket.readBytesMessage { (bytes, op, fin) in
            guard let bytes = bytes else {
                socket.close()
                if let player = self.player {
                    NSLog("Socket closed for \(player.id)")
                    Game.shared.leave(player: player)
                }
                return
            }
            
            do {
                
                let wsRequest = try JSONDecoder().decode(WSRequest.self, from:  Data(bytes: bytes))
                print(wsRequest)
                self.player = Player(id: wsRequest.username)
                
                if let player = self.player {
                    if wsRequest.position == nil {
                        Game.shared.join(player: player, socket: socket)
                    }else {
                        if let position = wsRequest.position {
                            Game.shared.update(player: player, position: position)
                        }else{
                            NSLog("Could not update position for \(player.id)")
                        }
                    }
                }
                self.handleSession(request: request, socket: socket)
            }catch {
                NSLog("Could not decode response")
                
            }
        }
    }
    
}

struct WSRequest: Encodable, Decodable {
    let username: String
    let position: Position?
}

