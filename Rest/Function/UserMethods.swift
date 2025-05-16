//
//  HelpMethos.swift
//  Rest
//
//  Created by Me Tomm on 7/5/2568 BE.
//

import Foundation
import Firebase

public class UserMethods {
    
    static let db = Firestore.firestore()
    static let userCol = db.collection("users")
    static let INFO_COL = "userInfo"
    static let INVITE_COL = "invite"
    static let VISIT_COL = "Visit"
    
    public static func updateUserInfoMatch(uid: String, col: String, matchField: String, matchValue: Any, newData: [String: Any]) {
        let colRef = userCol.document(uid).collection(col)
        
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

    
    public static func updateUserInfo(uid: String,col: String, data: [String : Any]){
        let colRef = userCol.document(uid).collection(col)
        
        colRef.getDocuments{ (querySnapshot, error ) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            
            guard let documents = querySnapshot?.documents.first else {
                print("No document found to update")
                return
            }
            
            let docRef = documents.reference
            
            docRef.updateData(data){ error in
                if let error = error {
                    print("Error updating document: \(error)")
                    
                }else{
                    print("Document successfully updated!")
                    
                }
            }
        }
    }
    
    public static func addUserInfo(uid: String, col: String, data: [String: Any]){
        let colRef = userCol.document(uid).collection(col)
        colRef.addDocument(data: data){error in
            if let error = error {
                print(error)
            }else{
                print("add document!")
            }
        }
    }
    
    public static func deleteUserInfo(uid: String, col: String){
        let colRef = userCol.document(uid).collection(col)
        colRef.getDocuments{ (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents to delete.")
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
                print("All documents deleted.")
            }
        }
    }
    
    
    
    
}
