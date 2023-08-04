//
//  APIError.swift
//  BBApp
//
//  Created by James Bellamy on 29/05/2021.
//

import Foundation

enum APIError: Error {
    case request(description: String)
    case response(description: String)
    case model(description: String)
}
