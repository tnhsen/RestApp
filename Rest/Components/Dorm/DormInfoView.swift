//
//  DormInfoView.swift
//  Rest
//
//  Created by Me Tomm on 21/4/2568 BE.
//

import SwiftUI

struct DormInfoView: View {
    
    var dorm : Dormitory
    
    var body: some View {
        
            GeometryReader { geometry in
                
                ZStack{
                    Screen()
                    
                    VStack{
                        
                        Text(dorm.name).font(.title)
                        
                        Image(systemName: "house").font(Font.system(size: 100)).frame(width: 150, height: 150).border(Color.black, width: 1)
                            .padding()
                        
                        var rent : String = String(format: "%.f", dorm.rent)
                        
                        Text("ค่าห้อง: \(rent) บาท/เดือน").fontWeight(.bold)
                        
                        var waterBill :String = String(format: "%.f", dorm.waterBill)
                        
                        Text("ค่าน้ำ: เหมาจ่าย \(waterBill) บาทต่อเดือน").fontWeight(.bold)
                        
                        var electricityBill : String = String(format: "%.1f", dorm.electricityBill)
                        
                        Text("ค่าไฟ: หน่วยกิตละ \(electricityBill) บาท").fontWeight(.bold)
                        
                        Text("จำนวนห้องที่ว่าง: \(dorm.dormFree)")
                        
                        Text("ที่อยู่: \(dorm.location)").multilineTextAlignment(.center)
                        
                        Text("เบอร์: \(dorm.phoneNumber)")
                        
                        NavigationLink(destination: FormRent(Dorm: dorm)){
                            Text("จองหอพัก").foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.6, height: 50)
                                .background(Color(hex: colorLevel1))
                                .cornerRadius(10)
                        }
                        
                    }.frame(width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.8)
                     .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                     
                }
            }
        }
    
}

struct DormInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DormInfoView(dorm : DataModel().dorm)
    }
}
