//
//  User.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//

import Foundation

struct User: Identifiable, Codable {
    var id: UUID = UUID()
    var email: String
    var password: String
}

public struct UserInfo: Identifiable ,Codable {
    public var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var profileImage: String
    var isDormitory: Bool
    var isAdmin: Bool
}

public struct UserInDorm: Identifiable ,Codable {
    public var id: UUID = UUID()
    var userId: String
    var electricUnit: Double
    var waterUnit: Double
}

