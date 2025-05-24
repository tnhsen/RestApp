//
//  NotiDetail.swift
//  Rest
//
//  Created by Me Tomm on 13/5/2568 BE.
//

import SwiftUI

struct BillNotiDetail: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.dismiss) var dismiss
    var bill: BillModel
    
    var body: some View {
        Group{
            ZStack{
                Screen4()
                
                VStack(spacing: 20){
                    VStack(spacing: 5){
                        Text("ใบแจ้งค่าหอ").font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: colorLevel4))
                        
                        
                    }
                    
                    VStack(spacing: 10){
                        Text("\(bill.DateBill) \(bill.Time) น.")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(Color(hex: colorLevel1))
                        
                        Divider().padding(.horizontal, 20)
                        
                        HStack{
                            Text("ค่าน้ำหน่วยละ").font(.system(size: 20, design: .rounded))
                                .foregroundColor(Color(hex: colorLevel1))
                            Spacer()
                            
                            var waterUnit: String = String(format: "%.f", bill.waterUnit)
                            Text("\(waterUnit) บาท").font(.system(size: 20, design: .rounded))
                                .foregroundColor(Color(hex: colorLevel1))
                        }
                        HStack{
                            Text("น้ำที่ใช้").font(.system(size: 18, design: .rounded))
                                .foregroundColor(.gray)
                            Spacer()
                            
                            var waterUse: String = String(format: "%.f", bill.waterUse)
                            Text("\(waterUse) หน่วย").font(.system(size: 18, design: .rounded))
                                .foregroundColor(.gray)
                        }.padding(.horizontal, 20)
                        
                        HStack{
                            Text("ค่าน้ำ").font(.system(size: 20, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            
                            var water: String = String(format: "%.f", bill.waterTotal)
                            Text("\(water) บาท").font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        Divider().padding(.horizontal, 20)
                        HStack{
                            Text("ค่าไฟหน่วยละ").font(.system(size: 20, design: .rounded))
                                .foregroundColor(Color(hex: colorLevel1))
                            Spacer()
                            
                            var eleUnit: String = String(format: "%.f", bill.eleUnit)
                            Text("\(eleUnit) บาท").font(.system(size: 20, design: .rounded))
                                .foregroundColor(Color(hex: colorLevel1))
                        }
                        HStack{
                            Text("ไฟที่ใช้").font(.system(size: 18, design: .rounded))
                                .foregroundColor(.gray)
                            Spacer()
                            
                            var eleUse: String = String(format: "%.f", bill.eleUse)
                            Text("\(eleUse) หน่วย").font(.system(size: 18, design: .rounded))
                                .foregroundColor(.gray)
                        }.padding(.horizontal, 20)
                        
                        HStack{
                            Text("ค่าไฟ").font(.system(size: 20, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            
                            var ele: String = String(format: "%.f", bill.eleTotal)
                            Text("\(ele) บาท").font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        Divider().padding(.horizontal, 20)
                        HStack{
                            Text("ค่าอินเตอร์เน็ต").font(.system(size: 20, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            
                            var internet: String = String(format: "%.f" , bill.internet)
                            Text("\(internet) บาท").font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        HStack{
                            Text("ค่าหอ").font(.system(size: 20, design: .rounded))
                                .foregroundColor(.black)
                            Spacer()
                            
                            var rent: String = String(format: "%.f" , bill.rent)
                            Text("\(rent) บาท").font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(.black)
                        }
                        Divider().padding(.horizontal, 20)
                        HStack{
                            Text("รวมทั้งหมด").font(.system(size: 25, design: .rounded))
                                .foregroundColor(Color(hex: colorBlueLevel1))
                            Spacer()
                            
                            var total: String = String(format: "%.f" , bill.Total)
                            Text("\(total) บาท").font(.system(size: 25, weight: .medium, design: .rounded))
                                .foregroundColor(.red)
                        }
                        
                        Text("โปรดชำระภายในวันที่ \(bill.DatePaidUntil) 23.59 น").font(.system(size: 14, design: .rounded))
                            .foregroundColor(.gray)
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    
                    Button(action: {
                        dataModel.PaidBill(bill: bill)
                    }) {
                        HStack {
                            Image(systemName: "printer.fill")
                            Text("ชำระค่าหอ")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: colorLevel3))
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                    }
                    .padding(.horizontal)
                    
                }
                .padding()

                
                
            }
        }
        .alert(isPresented: $dataModel.showAlert) {
                        Alert(
                            title: Text(dataModel.alertStatus),
                            message: Text(dataModel.alertDetail),
                            dismissButton: .default(Text("OK")) {
                                dataModel.showAlert = false
                                dismiss()
                            }
                        )
                    }
    }
}

struct NotiDetail_Previews: PreviewProvider {
    static var previews: some View {
        BillNotiDetail(bill: DataModel().bill)
    }
}
