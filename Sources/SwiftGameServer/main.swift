import PerfectWebSockets
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

let server = HTTPServer()

server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()

routes.add(method: .get, uri: "/game", handler: {
    request, response in
    WebSocketHandler(handlerProducer: {
        (request: HTTPRequest, protocols: [String]) -> WebSocketSessionHandler? in
              guard protocols.contains("game") else {
            return nil
        }
        return GameHandler()
    }).handleRequest(request: request, response: response)
})


server.addRoutes(routes)
Game.shared.start()


do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error: \(err) \(msg)")
}



