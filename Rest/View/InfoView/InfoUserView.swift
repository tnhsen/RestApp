//
//  InfoUserView.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct InfoUserView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedStatus = "แจ้งซ่อม"
    @State private var detailText = ""
    let statusOptions = ["แจ้งซ่อม", "ย้ายห้อง", "ย้ายออก", "อื่นๆ"]

    var body: some View {
        Group{
            GeometryReader{ geometry in
                ZStack{
                    Screen()
                    
                    VStack(spacing: 20){
                        Text("แบบฟอร์มการแจ้ง")
                            .font(.title2)
                            .bold()
                        
                        Picker("สถานะ", selection: $selectedStatus) {
                            ForEach(statusOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        TextField("รายละเอียดเพิ่มเติม", text: $detailText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        Button(action: {
                            dataModel.Report(status: selectedStatus, detail: detailText)
                            FetchData.fetchData(dataModel: dataModel)
                        }) {
                            Text("อัปโหลด")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: colorLevel1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        
                        Divider().padding(.top)
                        
                        
                        Text("รายการแจ้งทั้งหมด")
                            .font(.headline)
                            .padding(.top)

                        ScrollView {
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
                        .frame(width: geometry.size.width * 0.8, height: 200)
                        
                    } .frame(width: geometry.size.width * 0.8,
                               height: geometry.size.height * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }
        }.onAppear(){
            FetchData.fetchData(dataModel: dataModel)
        }
    }
}


struct InfoUserView_Previews: PreviewProvider {
        static var previews: some View {
            InfoUserView().environmentObject(DataModel())
    }
}
