//
//  AdminMethods.swift
//  Rest
//
//  Created by Me Tomm on 7/5/2568 BE.
//

import Foundation
import Firebase
import FirebaseFirestore

public class AdminMethods {
    static let db = Firestore.firestore()
    static let dormCol = db.collection("dormitory")
    
    static let VISIT_COL = "Visit"


    public static func deleteDocument(col: String, doc: String) {
        let db = Firestore.firestore()
        
        db.collection(col).document(doc).delete { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("dalete complete successfully")
            }
        }
    }

    
    public static func updateDormInfoMatch(did: String, col: String, matchField: String, matchValue: Any, newData: [String: Any]) {
        let colRef = dormCol.document(did).collection(col)
        
        colRef.whereField(matchField, isEqualTo: matchValue).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding document: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No matching documents found.")
                return
            }

            for document in documents {
                document.reference.updateData(newData) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated!")
                    }
                }
            }
        }
    }
    
    public static func addDormInfo(did: String, col: String, data: [String : Any]){
        let colRef = dormCol.document(did).collection(col)
        print("👉 Writing to path: dormitory/\(did)/\(col)")
        colRef.addDocument(data: data){error in
            if let error = error {
                print(error)
            }else{
                print(data)
            }
        }
    }
    
    public static func updateDorm(did: String,col: String, data: [String: Any]){
        let colRef = dormCol.document(did).collection(col)
        colRef.getDocuments{ (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let document = querySnapshot?.documents.first else {
                print("No document found to update")
                return
            }
            let docRef = document.reference
            docRef.updateData(data) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated!")
                }
            }
        }
    }
    
    public static func createRoom(room: String ,did: String){
        guard let roomCount = Int(room) else{
            print("Invalid room number.")
            return
        }
        let colRef = dormCol.document(did).collection("Room")
        for i in 1...roomCount{
            let roomData: [String: Any] = [
                "did": did,
                "number": i,
                "owner": "",
                "ownerUserId": "",
                "status": "",
                "dateMoveIn": "",
                "datePromise": "",
                "electricityUse": "",
                "waterUse": "",
                "isOwn": false,
                "isWaiting" : false
            ]
            colRef.document("\(i)").setData(roomData){ error in
                if let error = error {
                    print("❌ Error creating room \(i): \(error.localizedDescription)")
                }else{
                    print("✅ Room \(i) created successfully.")
                }
            }
        }
    }
    
    public static func updateRoomData(did: String,room: Int, data: [String: Any]){
        let colRef = dormCol.document(did).collection("Room")
        let docRef = colRef.document("\(room)")
        docRef.updateData(data){ error in
            if let error = error {
                print("Error updating document: \(error)")
            }else{
                print("Room document successfully updated")
            }
        }
    }
    
    public static func inviteUser(user: UserInfo, room: RoomModel, dorm: Dormitory){
        let colRef = db.collection("users").document(user.id).collection("invite")
        let data: [String: Any] = [
            "invite": true,
            "dormName": dorm.name,
            "dormId": dorm.id,
            "userId": user.id,
            "room": room.number
            ]
        colRef.addDocument(data: data){ error in
            if let error = error {
                print(error)
            }else{
                print("Invate Success!")
            }
        }
    }
    
    public static func userAcceptInvite(invite: InviteModel, data: [String: Any]){
        let colRef = dormCol.document(invite.dormId).collection("Room")
        let roomRef = colRef.document("\(invite.room)")
    }
    
    
    public static func deleteDormVisite(did: String, col: String, uid: String){
        let colRef = dormCol.document(did).collection(col)
        
        colRef.whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No matching documents to delete.")
                return
            }
            let group = DispatchGroup()
            for document in documents {
                group.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting document \(document.documentID): \(error)")
                    } else {
                        print("Successfully deleted document \(document.documentID)")
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                print("All matching documents deleted.")
            }
        }
    }

    
}

