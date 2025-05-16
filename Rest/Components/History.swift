//
//  History.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct BillHistory: View {
    
    var bill: BillModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(bill.name).font(.title2)
            
            HStack(spacing: 50){
                Text("Date: " + bill.DateBill).frame(alignment: .leading)
                    
                Text("Time: " + bill.Time + " น.").frame(alignment: .trailing)
            }
            
            var billTotal = String(format: "%.2f", bill.Total)
            Text(billTotal + " บาท")
            
        }
        .frame(width: 300, height: 110)
        .border(Color.black, width: 1)
        .padding(5)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        BillHistory(bill: DataModel().bill)
    }
}
