//
//  ReportCard.swift
//  Rest
//
//  Created by Me Tomm on 14/5/2568 BE.
//

import SwiftUI
struct ReportCard: View {
    var report: ReportModel
    
    public var body: some View {
        NavigationLink(destination: ReportDetail(report: report)) {
            ZStack(alignment: .trailing) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(report.status)
                            .font(.headline)
                            .foregroundColor(Color.black)
                        Spacer()
                        Text("\(report.dateReport) \(report.timeReport)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text("จากห้อง \(report.room)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !report.detail.isEmpty {
                        Text(report.detail)
                            .font(.body)
                            .foregroundColor(Color(hex: colorLevel1))
                    }
                }
                .padding()
                
                if(report.isResolve){
                    
                     Image(systemName: "checkmark.circle")
                         .font(.system(size: 40))
                         .foregroundColor(Color(hex: colorLevel1))
                         .padding()
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 2, y: 2)
            .padding(.horizontal, 5)
        }
        .buttonStyle(.plain)
    }
}

//struct RepeatedReportCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ReportCard(report: ReportModel(uid: "", did: "", room: 5, status: "แจ้งซ่อม", detail: "แอร์ไม่เย็นเลยครับ", dateReport: "14/05/2568", timeReport: "23.00", dateResolve: "", timeResolve: "", isResolve: false))
//    }
//}
