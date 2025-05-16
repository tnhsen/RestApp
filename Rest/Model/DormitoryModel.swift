//
//  Dormitory.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import Foundation

public struct Dormitory : Codable, Identifiable {
    public var id: String
    var name: String
    var room: String
    var img: String
    var rent: Double
    var electricityBill : Double
    var waterBill : Double
    var internetBill : Double
    var location : String
    var dormFree : String
    var isFull : Bool
    var phoneNumber : String
    var owner : String
}

struct DormitoryData : Codable, Identifiable {
    var id : UUID = UUID()
    var usedElectricity : Double
    var moveinDate : String
    var promiseDate : String
}

struct DormitorySearch : Codable, Identifiable {
    var id : UUID = UUID()
    var name : String
    var rentRate : Double
    var isFull : Bool
    var img : String
}


