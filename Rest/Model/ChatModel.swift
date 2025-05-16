//
//  ChatModel.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import Foundation

public struct ChatModel{
    let id: String
    let senderId: String
    let senderName: String
    let text: String
    let timestamp: Date
    let seen: Bool
}

public struct ChatMetaModel {
    let chatId: String
    let members: [String]
    let membersName: [String]
    let lastMessage: String
    let lastTimestamp: Date
}
