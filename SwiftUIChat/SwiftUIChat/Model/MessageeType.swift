//
//  MessageeType.swift
//  SwiftUIChat
//
//  Created by Korashi on 25/01/2023.
//

import Foundation

/// A type container associated with message body.
enum MessageType: Codable {
    case text(_ text: String)
    case image(_ imageUrl: String)
}
