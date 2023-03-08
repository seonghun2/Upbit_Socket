//
//  RequestMessage.swift
//  Upbit_Socket
//
//  Created by user on 2023/03/06.
//

import Foundation

// MARK: - RequestMessageElement
struct RequestMessageElement: Codable {
    let ticket, type: String?
    let codes: [String]?
}

typealias RequestMessage = [RequestMessageElement]
