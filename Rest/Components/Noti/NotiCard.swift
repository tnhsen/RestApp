//
//  Noti.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct BillNotiCard: View {
    
    var bill : BillModel
    
    var body: some View {
        NavigationLink(destination: BillNotiDetail(bill: bill)){
            VStack(alignment: .leading, spacing: 10){
                Text("แจ้งค่าห้อง").font(.title2).bold()
                
                HStack(spacing: 40){
                    Text("วันที่: \(bill.DateBill)").frame(alignment: .leading).opacity(0.5)
                        
                    Text("เวลา: \(bill.Time) น.").frame(alignment: .trailing).opacity(0.5)
                }
                
                var total: String = String(format: "%.f" , bill.Total)
                Text("คุณมีค่าหอที่ต้องชำระ \(total) บาท โปรดชำระภายในวันที่ \(bill.DatePaidUntil) เวลา 23.59 น")
                
            }
            .padding(5)
            .frame(width: 300, height: 110)
            .border(Color.black, width: 1)
        }.buttonStyle(.plain)
        
    }
}

struct Noti_Previews: PreviewProvider {
    static var previews: some View {
        BillNotiCard(bill: DataModel().bill)
    }
}
