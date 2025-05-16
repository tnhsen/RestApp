//
//  Dorm.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct Dorm: View {
    
    var dormitory: Dormitory
    
    var room: RoomModel
     
    var body: some View {
        
        VStack{
            if dormitory.img ==  "" {
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
                
            Text(dormitory.name).font(.title)
            
            VStack(alignment: .leading){
                
                Text("ห้อง: \(room.number)")
                
                var rent : String = String(format: "%.f", dormitory.rent)
                Text("ค่าห้อง: " + rent + " บาท / เดือน")
                
                var electricityBill : String = String(format: "%.1f", dormitory.electricityBill)
                Text("ค่าไฟหน่วยกิตละ: " + electricityBill + " บาท")
                
                var waterBill : String = String(format: "%.1f", dormitory.waterBill)
                Text("ค่าน้ำ: " + waterBill + " บาท")
             
                Text("---------------------------------")
                    .padding()
                
                Text("วันที่เข้าอยู่: " + room.dateMoveIn)
                    .font(Font.body.bold())
                
                Text("วันครบสัญญา: " + room.datePromise).font(Font.body.bold())
                
                var ele = Double(room.electricityUse) ?? 0
                var water = Double(room.waterUse) ?? 0
                var billElectricity = String(format: "%.2f", ele * dormitory.electricityBill)
                
                var billWater = String(format: "%.f", water * dormitory.waterBill)
                Text("ค่าไฟเดือนนี้: " + billElectricity)
                
                Text("ค่าน้ำเดือนนี้: " + billWater)
            }
        }
    }
}

//struct Dorm_Previews: PreviewProvider {
//    static var previews: some View {
//        Dorm(dormitory: DataModel().dorm, dormInfo: DataModel().dormInfo)
//    }
//}
