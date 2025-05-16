//
//  InviteDetail.swift
//  Rest
//
//  Created by Me Tomm on 30/4/2568 BE.
//

import SwiftUI

struct InviteDetail: View {
    
    var invite: InviteModel
    @EnvironmentObject var dataModel: DataModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Group{
            ZStack{
                Screen3()
                
                VStack(spacing: 20){
                    Text("คำเชิญเข้าร่วมหอ").font(.title)
                    
                    Text("\(invite.dormName)").font(.title2)
                    
                    Text("ห้องที่: \(invite.room)").font(.title2)
                    
                    
                    
                    HStack{
                        
                        Button("ปฏิเสธ"){
                            dataModel.userDenyInvite(invite: invite)
                        }
                        .frame(width: 75, height: 35)
                        .background(Color(hex: colorLevel1))
                        .foregroundStyle(Color.white)
                        .cornerRadius(15)
                        .padding()
                        
                        
                        Button("ตอบรับ"){
                            dataModel.acceptDormInvite(invite: invite)
                        }
                        .frame(width: 75, height: 35)
                        .background(Color(hex: colorLevel4))
                        .foregroundStyle(Color.black)
                        .cornerRadius(15)
                        .padding()
                        
                    }
                    
                }
                .frame(width: 350, height: 300)
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

struct InviteDetail_Previews: PreviewProvider {
    static var previews: some View {
        InviteDetail(invite: DataModel().invite).environmentObject(DataModel())
    }
}
