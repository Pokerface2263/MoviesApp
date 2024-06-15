//
//  RequestToken.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation

struct RequestToken: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
