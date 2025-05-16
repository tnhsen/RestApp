//
//  FormRent.swift
//  Rest
//
//  Created by Me Tomm on 21/4/2568 BE.
//

import SwiftUI

struct FormRent: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    var Dorm: Dormitory
    
    var body: some View {
        Group{
            GeometryReader { geometry in
                ZStack{
                    Screen()
                    
                    VStack{
                        
                        Text("จองเข้าชม").font(.title)
                        Text("สำหรับ \(Dorm.name)").font(.title2)
                        
                        HStack(spacing: 10) {
                            TextField("First Name", text: $dataModel.userVisitForm .firstName)
                                .padding()
                                .frame(width: 150, height: 40)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .multilineTextAlignment(.trailing)
                            
                            TextField("Last Name", text: $dataModel.userVisitForm.lastName)
                                .padding()
                                .frame(width: 150, height: 40)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .multilineTextAlignment(.leading)
                        }
                        
                        TextField("Email", text: $dataModel.userVisitForm.email)
                            .padding()
                            .frame(width: 310, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)

                        TextField("Phone", text: $dataModel.userVisitForm.phone)
                            .padding()
                            .frame(width: 310 ,height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                        
                        TextField("Date Ex 12/05/2025", text: $dataModel.userVisitForm.date)
                            .padding()
                            .frame(width: 310 ,height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                        
                        
                        Button("จองหอพัก"){
                            dataModel.userVisitDorm(visit: dataModel.userVisitForm)
                        }
                        .foregroundColor(.white)
                            .frame(width: geometry.size.width * 0.6, height: 50)
                            .background(Color(hex: colorLevel1))
                            .cornerRadius(10)
                            .padding()

                        
                    }
                    .frame(width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.8)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.6)
                }
            }
        }
        .alert(isPresented: $dataModel.showAlert) {
                        Alert(
                            title: Text(dataModel.alertStatus),
                            message: Text(dataModel.alertDetail),
                            dismissButton: .default(Text("OK")) {
                                dataModel.showAlert = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
        .onAppear(){
            dataModel.formGetInfo(dorm: Dorm)
        }
    }
}


struct FormRent_Previews: PreviewProvider {
    static var previews: some View {
        FormRent(Dorm: DataModel().dorm).environmentObject(DataModel())
    }
}
