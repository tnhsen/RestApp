//
//  DormAdmin.swift
//  Rest
//
//  Created by Me Tomm on 23/4/2568 BE.
//

import SwiftUI

struct DormAdmin: View {
    
    @EnvironmentObject var dataModel: DataModel
    
    var dorm: Dormitory
    
    var body: some View {
        
        VStack{
            if dorm.img == "" {
                Image(systemName: "house").font(.system(size: 120))
                    .border(Color.gray, width: 1)
                    .padding()
                    .foregroundColor(Color.gray)
            }else{
                Image(systemName: "house").font(.system(size: 120))
                    .border(Color.gray, width: 1)
                    .padding()
                    .foregroundColor(Color.gray)
            }
            
            Text(dorm.name).font(.title)
            
            Text("ผู้ดูแล").font(.title2)
            
            VStack(alignment: .leading){
                Text("จำนวนห้อง: \(dorm.room)")
                
                var rent: String = String(format: "%.f", dorm.rent)
                
                Text("ค่าห้อง: \(rent) บาท")
                
                var electricity: String = String(format: "%.f", dorm.electricityBill)
                
                Text("ค่าไฟ: \(electricity) บาท")
                
                var water: String = String(format: "%.f", dorm.waterBill)
                
                Text("ค่าน้ำ: \(water) บาท")
                
                Text("---------------------------------")
                    .padding()
                
                Text("จำนวนห้องที่ว่าง: \(dataModel.roomFree.count)")
                
                
                
            }
            
            Button("เรียกเก็บค่าหอ"){
                dataModel.UpdateAllBill()
            }.frame(width: 150, height: 35)
                .background(Color(hex: colorLevel4))
                .foregroundStyle(Color.black)
                .cornerRadius(15)
                .padding()
        }
        
    }
}

struct DormAdmin_Previews: PreviewProvider {
    static var previews: some View {
        DormAdmin(dorm: DataModel().dorm).environmentObject(DataModel())
    }
}
