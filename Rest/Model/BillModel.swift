//
//  Bill.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import Foundation

struct BillModel: Codable, Identifiable{
    var id: UUID = UUID()
    var did: String
    var uid: String
    var name: String
    var DateBill: String
    var DatePaidUntil: String
    var DatePaid: String
    var Time: String
    var TimePaid: String
    var Total: Double
    var eleUnit: Double
    var eleUse: Double
    var eleTotal: Double
    var waterUnit: Double
    var waterUse: Double
    var waterTotal: Double
    var internet: Double
    var rent: Double
    var isPaid: Bool
}
