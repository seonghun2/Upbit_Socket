//
//  ViewController.swift
//  Upbit_Socket
//
//  Created by user on 2023/03/06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var task: URLSessionWebSocketTask? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectSocket()
        sendMessage()
        receiveMessage()
    }
    
    func connectSocket() {
        let urlString = "wss://api.upbit.com/websocket/v1"
        guard let url = URL(string: urlString) else { return }
        task = URLSession.shared.webSocketTask(with: url)
        task?.resume()
    }
    
    func sendMessage() {
        let msg = #"[{"ticket":"test"},{"type":"ticker","codes":["KRW-BTC"]}]"#
        let message = URLSessionWebSocketTask.Message.string(msg)
        task?.send(message, completionHandler: { error in
            if error != nil {
                print("sendMessage Error")
            } else {
                print("message전송 성공")
            }
        })
    }
    
    func receiveMessage() {
        task?.receive { result in
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
                        DispatchQueue.main.async {
                            self.priceLabel.text = "BTC현재가: \(tradePrice)"
                        }
                    } catch {
                        
                    }
                default:
                    print("unknown")
                }
                self.receiveMessage()
            }
        }
    }
    
    @IBAction func disconnect() {
        print("disconnect")
        task?.cancel()
        task = nil
    }
    
    @IBAction func reconnect() {
        connectSocket()
        sendMessage()
        receiveMessage()
    }
}

