//
//  VisitModer.swift
//  Rest
//
//  Created by Me Tomm on 9/5/2568 BE.
//

import Foundation

struct UserVisitModel: Identifiable, Hashable {
    var id: UUID = UUID()
    var uid: String
    var did: String
    var dormName: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var date: String
    var isVisited: Bool
}
