//
//  ChatMethods.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import Foundation
import Firebase

public class ChatMethods{
    
    static let db = Firestore.firestore()
    
    public static func addChat(senderUID: String, senderName: String, receiverUID: String,username: String, message: String){
        let chatId = [senderUID, receiverUID].sorted().joined(separator: "_")
        let colRef = db.collection("chats").document(chatId).collection("message")
        
        let messageData: [String: Any] = [
                "senderId": senderUID,
                "senderName": senderName,
                "text": message,
                "timestamp": Timestamp(),
                "seen": false
            ]
        colRef.addDocument(data: messageData){error in
            if let error = error {
                print(error)
            }else{
                print("add document!")
            }
        }
        let chatMetaData: [String: Any] = [
            "members": [senderUID, receiverUID],
            "membersName": ["Admin", username],
            "lastMessage": message,
            "lastTimestamp": Timestamp()
        ]

        db.collection("chats").document(chatId).setData(chatMetaData, merge: true)
    }

    
}

func getOtherUserMember(chat: ChatMetaModel, dataModel: DataModel) -> String {

    
    if !dataModel.userInfo.isAdmin {
        return "Admin"
    }
    

    return chat.membersName.first(where: { $0 != "Admin" }) ?? "Unknown"
}


func getUserMamber(chat: ChatMetaModel, dataModel: DataModel)-> String {
    
    return chat.membersName.first(where: { $0 != "Admin" }) ?? "Unknown"
}


public func getOtherUserId(from chatId: String, currentUserId: String) -> String {
    return chatId
        .components(separatedBy: "_")
        .filter { $0 != currentUserId }
        .first ?? ""
}

