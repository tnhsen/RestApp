//
//  UserDatail.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct UserDatail: View {
    
    @EnvironmentObject var dataModel: DataModel
    
    var user: UserInfo
    var room: RoomModel
    var body: some View {
        if dataModel.NavigateToMain{
            MainView()
        }else{
            GeometryReader{ geometry in
                ZStack{
                    
                    Screen2()
                    
                    VStack(){
                        
                        ZStack{
                            if let image = dataModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 5)
                            } else {
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.3)
                                    .frame(width: 100)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        
                        Text("\(user.firstName) \(user.lastName)").font(.title)
                        Text("\(user.email)").font(.title2)
                        Text("\(user.phone)").font(.title2)
                        
                        Text("---------------------------------")
                            .padding()
                        
                        Text("คำเชิญจะถูกส่งไปยังผู้ใข้ \nเมื่อผู้ใช้ตอบรับคำเขิญ\nจึงจะถูกเพิ่มเข้าระบบ").multilineTextAlignment(.center)
                        
                        
                        Text("---------------------------------")
                            .padding()
                        
                        
                        Button("ลงทะเบียนผู้เช่า"){
                            dataModel.inviteUserToDorm(user: user, dorm: dataModel.dorm, room: room)
                        }.foregroundColor(.white)
                            .frame(width: geometry.size.width / 1.5 , height: 50)
                            .background(Color(hex: colorLevel1))
                            .cornerRadius(10)
                            .padding()
                        
                    }.frame(width: geometry.size.width * 0.8,
                            height: geometry.size.height * 0.8)
                     .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
            }.alert(isPresented: $dataModel.showAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Your invite has been savnt."),
                    dismissButton: .default(Text("OK")) {
                        dataModel.NavigateToMain = true
                    }
                )
            }
        }
    }
}

struct UserDatail_Previews: PreviewProvider {
    static var previews: some View {
        UserDatail(user: DataModel().userInfo, room: DataModel().room).environmentObject(DataModel())
    }
}
