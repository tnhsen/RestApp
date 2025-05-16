//
//  ReportDetail.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import SwiftUI

struct ReportDetail: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    var report: ReportModel

    var body: some View {
        Group{
            ZStack {
                Screen4()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                VStack(spacing: 20) {
                    Text("รายละเอียดการแจ้งซ่อม")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("\(report.status)")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Spacer()
                            if report.isResolve {
                                Label("แก้ไขแล้ว", systemImage: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Label("ยังไม่แก้", systemImage: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }

                        Divider()

                       
                        Label("ห้อง \(report.room)", systemImage: "house")
                            .font(.body)
                            .foregroundColor(.primary)

                  
                        VStack(alignment: .leading, spacing: 8) {
                            Label("รายละเอียด", systemImage: "doc.text")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text(report.detail.isEmpty ? "-" : report.detail)
                                .foregroundColor(.black.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Label("วันที่แจ้ง", systemImage: "calendar.badge.exclamationmark")
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("\(report.dateReport) เวลา \(report.timeReport)")
                                .foregroundColor(.black.opacity(0.7))
                        }

                        if report.isResolve {
                            VStack(alignment: .leading, spacing: 4) {
                                Label("วันที่แก้ไข", systemImage: "wrench.and.screwdriver")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Text("\(report.dateResolve) เวลา \(report.timeResolve)")
                                    .foregroundColor(.black.opacity(0.7))
                            }
                        }else{
                            if(dataModel.userInfo.isAdmin){
                                Button(action: { dataModel.resoveReport(uid: report.uid, did: report.did, report: report)}) {
                                    Text("แก้ปัญหา").frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.green)
                                .padding(.top, 16)
                            }
                        }
                        
                        

                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal)

                    Spacer()
                }
                
                
            }
        }.alert(isPresented: $dataModel.showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your information has been saved."),
                dismissButton: .default(Text("OK")) {
                    dataModel.showAlert = false
                    
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}


//struct ReportDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportDetail(report: ReportModel(uid: "", did: "", room: 5, status: "แจ้งซ่อม", detail: "แอร์แบบใดร้อนกว่าตอนปิด", dateReport: "12/12/2556", timeReport: "23.40", dateResolve: "15/05/2567", timeResolve: "12.00", isResolve: true)).environmentObject(DataModel())
//    }
//}
