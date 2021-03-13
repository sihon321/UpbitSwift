//
//  Payload.swift
//  upbit-swift
//
//  Created by ocean on 2021/03/11.
//

import Foundation
import SwiftJWT

public struct Payload: Claims {
    let access_key: String
    let nonce: String
    let query_hash: String
    let query_hash_alg: String
}
