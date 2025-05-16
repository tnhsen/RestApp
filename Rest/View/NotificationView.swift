//
//  NotificationView.swift
//  Rest
//
//  Created by Me Tomm on 28/3/2568 BE.
//

import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedCategory: String = "ทั้งหมด"
    
    let categories = ["ทั้งหมด", "คำขอเข้าชม", "แจ้งปัญหา"]
    
    var body: some View {
        Group{
            GeometryReader { geometry in
                ZStack {
                    
                    Screen()
                    
                    VStack {
                        if dataModel.userInfo.isAdmin {

                            Picker("หมวดหมู่", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            
                            ScrollView {
                                VStack {
                                    if selectedCategory == "ทั้งหมด" || selectedCategory == "คำขอเข้าชม" {
                                        ForEach(dataModel.userVisitList) { vis in
                                            VisitAdminCard(visit: vis)
                                        }
                                    }
                                    
                                    if selectedCategory == "ทั้งหมด" || selectedCategory == "แจ้งปัญหา" {
                                        ForEach(dataModel.reportList.sorted(by: { lhs, rhs in
                                            return convertDateTime(
                                                date: lhs.dateReport,
                                                time: lhs.timeReport) > convertDateTime(
                                                    date: rhs.dateReport,
                                                    time: rhs.timeReport)
                                            })) { rp in
                                            ReportCard(report: rp)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .frame(width: geometry.size.width * 0.8,
                                   height: geometry.size.height * 0.8)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
                            
                        } else {
                            ScrollView {
                                ForEach(dataModel.billNoti) { bill in
                                    if !bill.isPaid {
                                        BillNotiCard(bill: bill)
                                    }
                                }
                                .padding()
                            }
                            .frame(width: geometry.size.width * 0.8,
                                   height: geometry.size.height * 0.8)
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                    }
                }
            }
        }.onAppear(){
            FetchData.fetchData(dataModel: dataModel)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(DataModel())
    }
}
