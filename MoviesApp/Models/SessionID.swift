//
//  SessionID.swift
//  MoviesApp
//
//  Created by Pokerface on 24.02.2024.
//

import Foundation

struct SessionID: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case sessionId = "session_id"
    }
}
