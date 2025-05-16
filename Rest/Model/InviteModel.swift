//
//  InviteModel.swift
//  Rest
//
//  Created by Me Tomm on 30/4/2568 BE.
//

import Foundation

public struct InviteModel: Identifiable, Codable {
    public var id: UUID = UUID()
    var dormId: String
    var userId: String
    var dormName: String
    var invite: Bool
    var room: Int
}
