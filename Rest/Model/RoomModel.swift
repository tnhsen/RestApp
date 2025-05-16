//
//  RoomModel.swift
//  Rest
//
//  Created by Me Tomm on 27/4/2568 BE.
//

import Foundation
import Firebase

public struct RoomModel: Identifiable {
    public var id: UUID = UUID()
    var did: String
    var number: Int
    var owner: String
    var ownerUserId: String
    var status: String
    var dateMoveIn: String
    var datePromise: String
    var electricityUse: String
    var waterUse: String
    var isOwn: Bool
    var isWaiting: Bool
    var isWaitForPaid: Bool
}
