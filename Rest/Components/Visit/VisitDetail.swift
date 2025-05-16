//
//  VisitDetail.swift
//  Rest
//
//  Created by Me Tomm on 12/5/2568 BE.
//

import SwiftUI

struct VisitDetail: View {
    var visite: UserVisitModel
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group{
            ZStack{
                Screen3()
                
                VStack(spacing: 20){
                    Text("คำขอเข้าชมหอ").font(.title)
                    
                    Text("วันที่: \(visite.date)").font(.title2).foregroundStyle(Color.gray)
                    
                    Text("ผู้เข้าชม: \(visite.firstName) \(visite.lastName)").font(.title2)
                    
                    Text("email: \(visite.email)")
                    Text("phone: \(visite.phone)")
                    
                    
                    
                    
                    HStack{
                        
                        
                        
                        Button("เข้าชมแล้ว"){
                            dataModel.deleteVisitDorm(visit: visite)
                        }
                        .frame(width: 100, height: 35)
                        .background(Color(hex: colorLevel4))
                        .foregroundStyle(Color.black)
                        .cornerRadius(15)
                        .padding()
                        
                    }
                    
                }
                .frame(width: 350, height: 350)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }.onAppear(){
            
        }
        .alert(isPresented: $dataModel.showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Your information has been saved."),
                            dismissButton: .default(Text("OK")) {
                                
                                presentationMode.wrappedValue.dismiss()
                                
                            }
                        )
                    
        }
    }
}
