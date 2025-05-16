//
//  ChatCard.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import SwiftUI

struct ChatCard: View {
    @EnvironmentObject var dataModel: DataModel
    var chat: ChatMetaModel
    var body: some View {
        NavigationLink(destination: ChatMessageView(chat: chat)) {
            VStack(alignment: .leading) {
                
                Text(getOtherUserMember(chat: chat, dataModel: dataModel))
                    .font(.headline)
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(chat.lastTimestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

//
//struct ChatCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatCard(chat: ChatMetaModel(chatId: "123456", members: ["Gay", "Na"], lastMessage: "Gay", lastTimestamp: Date()) ).environmentObject(DataModel())
//    }
//}
