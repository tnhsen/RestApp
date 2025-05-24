//
//  Dashboard.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import SwiftUI

enum DashboardType: String, CaseIterable {
    case all = "รวมทั้งหมด"
    case monthly = "รายเดือน"
}

struct DashboardCombinedView: View {
    @EnvironmentObject var dataModel: DataModel

    @State private var selectedType: DashboardType = .all
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    private let months = Calendar.current.monthSymbols

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Picker("ประเภท", selection: $selectedType) {
                    ForEach(DashboardType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                if selectedType == .monthly {
                    Picker("เลือกเดือน", selection: $selectedMonth) {
                        ForEach(1..<13) { index in
                            Text(months[index - 1]).tag(index)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                if selectedType == .all {
                    DashboardSumView(dashboard: totalDashboard, title: "📊 สรุปรวมทั้งหมด")
                } else {
                    DashboardSumView(dashboard: monthlyDashboard, title: "📅 สรุปประจำเดือน \(months[selectedMonth - 1])")
                }
            }
            .padding()
        }
    }

    var totalDashboard: DashboardModel {
        calDashBoard(
            bills: dataModel.billHistory,
            reports: dataModel.reportList,
            roomOwnList: dataModel.roomOwnList,
            selectedMonth: nil,
            selectedYear: nil
        )
    }

    var monthlyDashboard: DashboardModel {
        let filteredBills = dataModel.billHistory.filter {
            Calendar.current.component(.month, from: convertDateTime(date: $0.DateBill, time: $0.Time)) == selectedMonth &&
            Calendar.current.component(.year, from: convertDateTime(date: $0.DateBill, time: $0.Time)) == currentYear
        }

        let filteredReports = dataModel.reportList.filter {
            Calendar.current.component(.month, from: convertDateTime(date: $0.dateReport, time: $0.timeReport)) == selectedMonth &&
            Calendar.current.component(.year, from: convertDateTime(date: $0.dateReport, time: $0.timeReport)) == currentYear
        }

        return calDashBoard(
            bills: filteredBills,
            reports: filteredReports,
            roomOwnList: dataModel.roomOwnList,
            selectedMonth: selectedMonth,
            selectedYear: currentYear
        )
    }

    var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
}


struct DashboardSumView: View {
    var dashboard: DashboardModel
    var title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.bottom, 4)

            GroupBox(label: Label("รายรับ", systemImage: "creditcard")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("รวมทั้งหมด: \(dashboard.totalBill, specifier: "%.f") บาท")
                    Text("ค่าไฟ: \(dashboard.eleUse, specifier: "%.f") หน่วย / \(dashboard.eleTotal, specifier: "%.f") บาท")
                    Text("ค่าน้ำ: \(dashboard.waterUse, specifier: "%.f") หน่วย / \(dashboard.waterTotal, specifier: "%.f") บาท")
                    Text("ค่าเน็ต: \(dashboard.internet, specifier: "%.f") บาท")
                    Text("ค่าเช่า: \(dashboard.rent, specifier: "%.f") บาท")
                }
            }

            GroupBox(label: Label("สถิติผู้เช่า", systemImage: "person.3.fill")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("จำนวนผู้เช่าทั้งหมด: \(dashboard.userIndorm) คน")
                }
            }

            GroupBox(label: Label("รายการปัญหา", systemImage: "exclamationmark.bubble.fill")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("รายการปัญหาทั้งหมด: \(dashboard.totalReport) เรื่อง")
                    Text("แก้ไขแล้ว: \(dashboard.resloveReport) เรื่อง")
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

func calDashBoard(bills: [BillModel], reports: [ReportModel], roomOwnList: [RoomModel], selectedMonth: Int?, selectedYear: Int?) -> DashboardModel {
    var dashBoard = DashboardModel(totalBill: 0, eleUse: 0, eleTotal: 0, waterUse: 0, waterTotal: 0, internet: 0, rent: 0, userIndorm: 0, totalReport: 0, resloveReport: 0)

    for b in bills {
        dashBoard.totalBill += b.Total
        dashBoard.eleUse += b.eleUse
        dashBoard.eleTotal += b.eleTotal
        dashBoard.waterUse += b.waterUse
        dashBoard.waterTotal += b.waterTotal
        dashBoard.internet += b.internet
        dashBoard.rent += b.rent
    }


    if let month = selectedMonth, let year = selectedYear {
        dashBoard.userIndorm = roomOwnList.filter { room in
            let moveInDate = room.dateMoveIn
            let moveInMonth = Calendar.current.component(.month, from: convertDateTime(date: moveInDate, time: "12:00"))
            let moveInYear = Calendar.current.component(.year, from: convertDateTime(date: moveInDate, time: "12:00"))

            return (moveInYear < year) || (moveInYear == year && moveInMonth <= month)
        }.count
    } else {
        dashBoard.userIndorm = roomOwnList.count
    }

    dashBoard.totalReport = reports.count
    dashBoard.resloveReport = reports.filter { $0.isResolve == true }.count

    return dashBoard
}

