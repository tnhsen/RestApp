//
//  ReportModel.swift
//  Rest
//
//  Created by Me Tomm on 14/5/2568 BE.
//

import Foundation

public struct ReportModel: Identifiable, Codable {
    public let id = UUID()
    let uid: String
    let did: String
    let name: String
    let room: Int
    let status: String
    let detail: String
    let dateReport: String
    let timeReport: String
    let dateResolve: String
    let timeResolve: String
    let isResolve: Bool
}
