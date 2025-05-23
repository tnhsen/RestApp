//
//  EditDormFormView.swift
//  Rest
//
//  Created by Me Tomm on 21/4/2568 BE.
//

import SwiftUI

struct EditDormFormView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Screen()
                
                Text("แก้ไขข้อมูลหอพัก").font(.title).position(x: geometry.size.width / 2, y: geometry.size.height / 15)
                
                VStack(spacing: 20){
                    TextField("ชื่อหอพัก", text: $dataModel.dorm.name)
                        .padding()
                        .frame(width: 275, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.center)
                    
                    TextField("ที่อยู่", text: $dataModel.dorm.location)
                        .padding()
                        .frame(width: 275, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.center)
                    
                    Text("ค่าหอ").foregroundStyle(Color.gray)
                    
                    TextField("ค่าหอ", text: Binding(
                        get: {
                            String(format: "%.0f", dataModel.dorm.rent)
                        },
                        set: { newValue in
                            if let value = Double(newValue) {
                                dataModel.dorm.rent = value
                            }
                        }
                    ))
                        .padding()
                        .frame(width: 275, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.center)
                    
                    Text("ค่าน้ำ / ค่าไฟ / ค่าเน็ต").foregroundStyle(Color.gray
                    )
                    HStack{
                        TextField("ค่าน้ำ", text: Binding(
                            get: {
                                String(format: "%.0f", dataModel.dorm.waterBill)
                            },
                            set: { newValue in
                                if let value = Double(newValue) {
                                    dataModel.dorm.waterBill = value
                                }
                            }
                        ))
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(width: 87, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                            
                        
                        TextField("ค่าไฟ", text: Binding(
                            get: {
                                String(format: "%.0f", dataModel.dorm.electricityBill)
                            },
                            set: { newValue in
                                if let value = Double(newValue) {
                                    dataModel.dorm.electricityBill = value
                                }
                            }
                        ))

                            .padding()
                            .frame(width: 87, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                        
                        TextField("ค่าเน็ต", text: Binding(
                            get: {
                                String(format: "%.0f", dataModel.dorm.internetBill)
                            },
                            set: { newValue in
                                if let value = Double(newValue) {
                                    dataModel.dorm.internetBill = value
                                }
                            }
                        ))
                            .padding()
                            .frame(width: 87, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                    }
                    
                    
//                    TextField("จำนวนห้อง", text: $dataModel.dorm.room)
//                        .padding()
//                        .frame(width: 275, height: 40)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
//                        .multilineTextAlignment(.center)
//                    
                    TextField("เบอร์โทร", text: $dataModel.dorm.phoneNumber)
                        .padding()
                        .frame(width: 275, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Button("ยกเลิก"){
                            FetchData.fetchUserData(dataModel: dataModel)
                            presentationMode.wrappedValue.dismiss()
                        }.foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(Color.gray)
                            .cornerRadius(10)
                        
                        Button("บันทึก"){
                            dataModel.updateDorm()
                        }.foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(Color(hex: colorLevel1))
                            .cornerRadius(10)
                        
                    }

                }.frame(width: geometry.size.width * 0.8,
                        height: geometry.size.height * 0.8)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 1.9)
                 
            }
        }.navigationBarBackButtonHidden(true)
            .alert(isPresented: $dataModel.showAlert) {
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

struct EditDormFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditDormFormView().environmentObject(DataModel())
    }
}
