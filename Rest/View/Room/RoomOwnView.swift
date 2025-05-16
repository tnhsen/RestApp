//
//  RoomOwnView.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct RoomOwnView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    var room: RoomModel
    
    @State private var showUpdateStatusAlert = false
    @State private var showUpdateBillSheet = false
    @State private var showDeleteAlert = false
    @State private var statusInputText = ""
    @State private var selectedWaterUse = 0
    @State private var selectedEleUse = 0
    
    var body: some View {
        Group{
            GeometryReader{ geometry in
                ZStack {

                    Screen2()
                    
                    VStack(spacing: 10) {
                        ZStack{
                            if(room.isWaitForPaid){
                                Circle()
                                    .fill(Color.orange)
                                    .opacity(0.3)
                                    .frame(width: 100)
                            }else{
                                Circle()
                                    .fill(Color.green)
                                    .opacity(0.3)
                                    .frame(width: 100)
                                
                            }
                            Image(systemName: "house").font(.system(size: 45))
                            
                        }.padding()
                        
                        Text("ห้อง: \(room.number)").font(.title)
                        
                        Text("ผู้เช่า: \(room.owner)").font(.title2)
                        
                        Text("วันย้ายเข้า: \(room.dateMoveIn)").font(.title3)
                        
                        Text("วันครบสัญญา: \(room.datePromise)").font(.title3)
                        
                        Text("---------------------------------")
                            
                        
                        Text("สถานะ: \(room.status)")
                        Text("ไฟฟ้าที่ใช้: \(room.electricityUse)")
                        Text("น้ำที่ใช้: \(room.waterUse)")
                        
                        let waterUse = Double(room.waterUse) as? Double ?? 0.0
                        let water = dataModel.dorm.waterBill * waterUse
                        
                        let electricityUse = Double(room.electricityUse) as? Double ?? 0.0
                        let electricity = dataModel.dorm.electricityBill * electricityUse
                        
                        
                        let RentString: String = String(format: "%.f", dataModel.dorm.rent)
                        
                        let waterString: String = String(format: "%.0f", water)
                        
                        let electricityString: String = String(format: "%.0f", electricity)
                        
                        let internetString: String = String(format: "%.f", dataModel.dorm.internetBill)
                        
                        Text("ค่าหอ: \(RentString)\nค่าน้ำ: \(waterString), ค่าไฟ: \(electricityString), ค่าเน็ต: \(internetString)").multilineTextAlignment(.center)
                        
                        Text("---------------------------------")
                            
                        
                        
                        
                    }
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                HStack(spacing: 20){
                    Button("อัพเดทสถานะ"){
                        statusInputText = ""
                        showUpdateStatusAlert = true
                    }.foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                    
                    Button("อัพเดทค่าหอ"){
                        showUpdateBillSheet = true
                    }.foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(Color(hex: colorLevel1))
                        .cornerRadius(10)
                }.position(x: geometry.size.width / 2 , y: geometry.size.height / 1.05)
                    

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }

        }
        
        .alert("ยืนยันการลบ", isPresented: $showDeleteAlert, actions: {
            Button("ลบ", role: .destructive) {
                dataModel.deleteUserFromRoom(room: room)
                showDeleteAlert = false
                presentationMode.wrappedValue.dismiss()
            }
            Button("ยกเลิก", role: .cancel) {
                showDeleteAlert = false
            }
        }, message: {
            Text("คุณแน่ใจหรือไม่ว่าต้องการลบผู้เช่าคนนี้ออกจากหอ?")
        })

        .alert("อัพเดทสถานะ", isPresented: $showUpdateStatusAlert, actions: {
            TextField("กรอกข้อความ", text: $statusInputText)
                    Button("ตกลง") {
                        dataModel.updateStatus(text: statusInputText, room: room)
                        print("updateStatus \(statusInputText)")
                    }
                    Button("ยกเลิก", role: .cancel) { }
                }, message: {
                    Text("โปรดกรอกข้อความเพื่ออัพเดทสถานะ")
                })
        
        .sheet(isPresented: $showUpdateBillSheet) {
                    VStack(spacing: 20) {
                        Text("อัพเดทค่าหอ").font(.title2).padding(.top)
                        
                        HStack {
                            VStack {
                                Text("หน่วยน้ำ")
                                Picker("น้ำ", selection: $selectedWaterUse) {
                                    ForEach(0..<500) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                            }
                            
                            VStack {
                                Text("หน่วยไฟ")
                                Picker("ไฟ", selection: $selectedEleUse) {
                                    ForEach(0..<500) { i in
                                        Text("\(i)").tag(i)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                            }
                        }
                        
                        HStack {
                            Button("ยกเลิก") {
                                showUpdateBillSheet = false
                            }
                            .padding()
                            .foregroundColor(.red)

                            Spacer()

                            Button("ตกลง") {
                                dataModel.UpdateBill(ele: Double(selectedEleUse), water: Double(selectedWaterUse), room: room)
                                print("update bill: \(selectedWaterUse), \(selectedEleUse)")
                                showUpdateBillSheet = false
                            }
                            .padding()
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                    }
                    .presentationDetents([.height(320)])
                }
            }
    
    
}


struct RoomOwnView_Previews: PreviewProvider {
    static var previews: some View {
        RoomOwnView(room: DataModel().room).environmentObject(DataModel())
    }
}
