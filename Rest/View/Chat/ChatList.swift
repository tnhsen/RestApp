//
//  ChatList.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        
        Group{
            if(dataModel.chatList.isEmpty){
                if(!dataModel.userInfo.isAdmin){
                    Button("เริ่มแชท"){
                        ChatMethods.addChat(senderUID: dataModel.userInfo.id, senderName: dataModel.userInfo.firstName + " " + dataModel.userInfo.lastName, receiverUID: dataModel.dorm.id, username: dataModel.getName(), message: "สวัสดี")
                    }.buttonStyle(.plain)
                }
            }else{
                List(dataModel.chatList, id: \.chatId) { chat in
                    ChatCard(chat: chat)
                }
            }
        }
        .navigationTitle("แชท")
        .onAppear(){
            FetchData.fetchData(dataModel: dataModel)
        }
        
    }
}
