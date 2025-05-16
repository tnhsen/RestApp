//
//  RoomNotOwnView.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct RoomNotOwnView: View {
    
    var room : RoomModel
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Screen2()
                
                VStack{
                    
                    if(room.isWaiting){
                        ZStack{
                            Circle()
                                .fill(Color.blue)
                                .opacity(0.3)
                                .frame(width: 100)
                            Image(systemName: "house").font(.system(size: 45))
                        }.padding()
                    }else{
                        ZStack{
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.3)
                                .frame(width: 100)
                            Image(systemName: "house").font(.system(size: 45))
                        }.padding()
                    }
                    
                    Text("ห้อง: \(room.number)").font(.title)
                    
                    Text("---------------------------------")
                        .padding()
                    
                    if(room.isWaiting){
                        Text("ส่งคำเชิญแล้ว\nกำลังรอให้ผู้เช่ากดตอบรับ").font(.title2).multilineTextAlignment(.center)
                    }else{
                        Text("ยังไม่มีผู้เช่า").font(.title2)
                    }
                    
                    Text("---------------------------------")
                        .padding()
                    
                    
                    if(room.isWaiting){
                        Text("ไม่สามารถยกเลิกคำเชิญได้\nกรุณารอผู้ให้กดตอบรับหรือปฏิเสธ").font(.title3).opacity(0.3).multilineTextAlignment(.center)
                    }else{
                        NavigationLink(destination: SearchUserView(room: room)){
                            Text("ลงทะเบียนผู้เช่า")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width / 1.5 , height: 50)
                                .background(Color(hex: colorLevel1))
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                    
                    
                }.frame(width: geometry.size.width * 0.8,
                        height: geometry.size.height * 0.8)
                 .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

struct RoomNotOwnView_Previews: PreviewProvider {
    static var previews: some View {
        RoomNotOwnView(room: DataModel().room)
    }
}
