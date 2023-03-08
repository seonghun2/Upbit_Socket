//
//  ViewController.swift
//  Upbit_Socket
//
//  Created by user on 2023/03/06.
//

import UIKit

class ViewController: UIViewController {
    
    var task = URLSession.shared.webSocketTask(with: URL(string: "wss://api.upbit.com/websocket/v1")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let msg = #"[{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC"]}]"#
        
        let message = URLSessionWebSocketTask.Message.string(msg)
        
        let urlString = "wss://api.upbit.com/websocket/v1"
        guard let url = URL(string: urlString) else { return }
        
        task.resume()
        task.send(message, completionHandler: { error in
            print("error: \(error?.localizedDescription)")
        })
        receiveMessage()
        
    }
    
    func receiveMessage() {
        task.receive { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let messageString):
                    print("messageString: \(messageString)")
                case .data(let data):
                    do {
                        let coinInfo = try JSONDecoder().decode(UpbitResponse.self, from: data)
                        guard let tradePrice = coinInfo.tradePrice else { return }
                        print("현재가: \(tradePrice)")
                    } catch {
                        
                    }
                default:
                    print("unknown")
                }
                self.receiveMessage()
            }
        }
    }
}

