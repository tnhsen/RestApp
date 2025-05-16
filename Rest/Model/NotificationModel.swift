//
//  Notification.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct Notification: Identifiable, Codable{
    var id: UUID = UUID()
    var title: String
    var message: String
    var date: String
    var time: String
}
