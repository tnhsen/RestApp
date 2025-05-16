//
//  HistoryCard.swift
//  Rest
//
//  Created by Me Tomm on 14/5/2568 BE.
//

import SwiftUI

struct BillHistoryCard: View {
    
    var bill: BillModel
    
    var body: some View {
        NavigationLink(destination: BillHistoryDetail(bill: bill)){
            VStack(alignment: .leading, spacing: 10){
                Text("ชำระเงินเสร็จสิ้น").font(.title2).bold()
                
                HStack(spacing: 40){
                    Text("วันที่: \(bill.DateBill)").frame(alignment: .leading).opacity(0.5)
                        
                    Text("เวลา: \(bill.Time) น.").frame(alignment: .trailing).opacity(0.5)
                }
                
                var total: String = String(format: "%.f" , bill.Total)
                Text("คุณได้ชำระค่าหอพัก \(total) บาท")
                
            }
            .padding(5)
            .frame(width: 300, height: 110)
            .border(Color.black, width: 1)
        }
        .buttonStyle(.plain)
    }
}

struct BillHistoryCard_Previews: PreviewProvider {
    static var previews: some View {
        BillHistoryCard(bill: DataModel().bill)
    }
}
