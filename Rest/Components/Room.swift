//
//  Room.swift
//  Rest
//
//  Created by Me Tomm on 23/4/2568 BE.
//

import SwiftUI

struct Room: View {
    var room: RoomModel
    var body: some View {
        NavigationLink(destination: RoomDetailView(room: room)){
            ZStack{
                VStack(spacing: 0.2){
                    ZStack{
                        
                        if (room.isOwn){
                            if(room.isWaitForPaid){
                                Circle()
                                    .fill(Color.orange)
                                    .opacity(0.3)
                                    .frame(width: 30)
                            }else{
                                Circle()
                                    .fill(Color.green)
                                    .opacity(0.3)
                                    .frame(width: 30)
                            }
                        }else{
                            if(room.isWaiting){
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(1)
                                    .frame(width: 30)
                            }else{
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.3)
                                    .frame(width: 30)
                            }
                        }
                        Image(systemName: "house")
                    }
                    
                    Text(String(room.number))
                    
                    
                    
                }.frame(width: 60, height: 60)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(radius: 25)
                
                
            }
        }.buttonStyle(PlainButtonStyle())
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room(room: DataModel().room)
    }
}
