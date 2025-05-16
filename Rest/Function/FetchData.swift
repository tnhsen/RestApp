//
//  FetchData.swift
//  Rest
//
//  Created by Me Tomm on 25/4/2568 BE.
//

import FirebaseAuth
import Firebase
import SwiftUI

let db = Firestore.firestore()

class FetchData {
    
    static let DORM: String = "dormitory"
    static let USER: String = "users"
    
    static func fetchData(dataModel: DataModel) {
        fetchUserData(dataModel: dataModel)
    }
    
    static func fetchUserData(dataModel: DataModel) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection("users").document(uid).collection("userInfo")
        colRef.getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in QuerySnapshot!.documents {
                let userData = document.data()
                DispatchQueue.main.async {
                    dataModel.userInfo.id = userData["id"] as? String ?? ""
                    dataModel.userInfo.firstName = userData["firstname"] as? String ?? ""
                    dataModel.userInfo.lastName = userData["lastname"] as? String ?? ""
                    dataModel.userInfo.phone = userData["phone"] as? String ?? ""
                    dataModel.userInfo.email = userData["email"] as? String ?? ""
                    dataModel.userInfo.profileImage = userData["img"] as? String ?? ""
                    dataModel.userInfo.isDormitory = userData["isDorm"] as? Bool ?? false
                    dataModel.userInfo.isAdmin = userData["isAdmin"] as? Bool ?? false
                    print("✅ Fetch Data Success!!")
                    if(dataModel.userInfo.isDormitory){
                        if(dataModel.userInfo.isAdmin){
                            fetchDormDataAsAdmin(dataModel: dataModel)
                            fectVisitList(type: FetchData.DORM, dataModel: dataModel)
                            fetchReport(type: DORM, dataModel: dataModel)
                            fetchBill(type: DORM, dataModel: dataModel)
                        }else{
                            fetchKeyToRoom(dataModel: dataModel)
                            fetchReport(type: USER, dataModel: dataModel)
                        }
                    }else{
                        fetchAllDormData(dataModel: dataModel)
                        fetchDormInvite(dataModel: dataModel)
                        fectVisitList(type: FetchData.USER, dataModel: dataModel)
                    }
                }
                DispatchQueue.main.async {
                    fetchChat(type: USER,dataModel: dataModel)
                    dataModel.calDashBoard()
                }
            }
        }
    }
    
    static func fetchChat(type: String, dataModel: DataModel) {
        let colRef = db.collection("chats")
        colRef.whereField("members", arrayContains: dataModel.userInfo.id)
            .order(by: "lastTimestamp", descending: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("❌ Error fetching chat list: \(error)")
                    return
                }
                
                var tempChatMetaList: [ChatMetaModel] = []
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    let chatId = document.documentID
                    let members = data["members"] as? [String] ?? []
                    let membersName = data["membersName"] as? [String] ?? []
                    let lastMessage = data["lastMessage"] as? String ?? ""
                    let timestamp = (data["lastTimestamp"] as? Timestamp)?.dateValue() ?? Date()
                    
                    let chatMeta = ChatMetaModel(
                        chatId: chatId,
                        members: members,
                        membersName: membersName,
                        lastMessage: lastMessage,
                        lastTimestamp: timestamp
                    )
                    
                    tempChatMetaList.append(chatMeta)
                }
                
                DispatchQueue.main.async {
                    dataModel.chatList = tempChatMetaList
                    print("✅ Fetch chat meta success: \(tempChatMetaList.count) chat(s)")
                }
            }
    }
    
    static func fetchMessages(chatId: String, dataModel: DataModel) {
        let colRef = db.collection("chats").document(chatId).collection("message")
        
        colRef.order(by: "timestamp", descending: false).getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching messages: \(error)")
                return
            }
            
            var tempMessages: [ChatModel] = []
            
            for document in snapshot!.documents {
                let data = document.data()
                
                let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                
                var message = ChatModel(
                    id: document.documentID,
                    senderId: data["senderId"] as? String ?? "",
                    senderName: data["senderName"] as? String ?? "",
                    text: data["text"] as? String ?? "",
                    timestamp: timestamp,
                    seen: data["seen"] as? Bool ?? false)
                
                
                tempMessages.append(message)
            }
            
            DispatchQueue.main.async {
                dataModel.chatMessage[chatId] = tempMessages
                print("✅ Fetch messages success: \(tempMessages.count) messages in chat \(chatId)")
            }
        }
    }

    
    static func fetchDormDataAsAdmin(dataModel: DataModel) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection("dormitory").document(uid).collection("Info")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        colRef.getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                dispatchGroup.leave()
                return
            }
            for document in QuerySnapshot!.documents {
                let dormData = document.data()
                DispatchQueue.main.async {
                    dataModel.dorm.id = dormData["id"] as? String ?? ""
                    dataModel.dorm.name = dormData["name"] as? String ?? ""
                    dataModel.dorm.room = dormData["room"] as? String ?? ""
                    dataModel.dorm.img = dormData["img"] as? String ?? ""
                    dataModel.dorm.rent = dormData["rent"] as? Double ?? 0
                    dataModel.dorm.electricityBill = dormData["electricityBill"] as? Double ?? 0
                    dataModel.dorm.waterBill = dormData["waterBill"] as? Double ?? 0
                    dataModel.dorm.internetBill = dormData["internetBill"] as? Double ?? 0
                    dataModel.dorm.location = dormData["location"] as? String ?? ""
                    dataModel.dorm.dormFree = dormData["dormFree"] as? String ?? ""
                    dataModel.dorm.isFull = dormData["isFull"] as? Bool ?? false
                    dataModel.dorm.phoneNumber = dormData["phoneNumber"] as? String ?? ""
                    dataModel.dorm.owner = dormData["owner"] as? String ?? ""
                    print("✅ Fetch DataDorm Success!!")
                    dispatchGroup.leave() // 👉 เสร็จแล้วค่อยออก
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("📦 Finished fetching dorm info, now fetching rooms...")
            fetchRoomsForAdmin(dataModel: dataModel)
        }
    }

    static func fetchRoomsForAdmin(dataModel: DataModel) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let roomsColRef = db.collection("dormitory").document(uid).collection("Room")

        roomsColRef.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("Error fetching rooms: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No room documents found.")
                return
            }
            var tempRoomList: [RoomModel] = []
            var tempRoomFree: [RoomModel] = []
            var tempRoomOwn: [RoomModel] = []
            for document in documents {
                let roomData = document.data()
                let room = RoomModel(
                    did: roomData["did"] as? String ?? "" ,number: roomData["number"] as? Int ?? 0,
                    owner: roomData["owner"] as? String ?? "",
                    ownerUserId: roomData["ownerUserId"] as? String ?? "",
                    status: roomData["status"] as? String ?? "",
                    dateMoveIn: roomData["dateMoveIn"] as? String ?? "",
                    datePromise: roomData["datePromise"] as? String ?? "",
                    electricityUse: roomData["electricityUse"] as? String ?? "",
                    waterUse: roomData["waterUse"] as? String ?? "",
                    isOwn: roomData["isOwn"] as? Bool ?? false,
                    isWaiting: roomData["isWaiting"] as? Bool ?? false,
                    isWaitForPaid: roomData["isWaitForPaid"] as? Bool ?? false
                )
                if(!room.isOwn){
                    tempRoomFree.append(room)
                }else{
                    tempRoomOwn.append(room)
                }
                tempRoomList.append(room)
            }
            DispatchQueue.main.async {
                dataModel.roomFree = tempRoomFree
                dataModel.roomOwnList = tempRoomOwn
                print("RoomOwn: \(dataModel.roomOwnList.count)")
                if(dataModel.roomFree.count == 0){
                    AdminMethods.updateDorm(did: uid, col: "Info", data: ["isFree": false])
                }
                dataModel.roomList = tempRoomList
                print("✅ Fetch Rooms Success! Total: \(tempRoomList.count) rooms.")
                fetchUser(dataModel: dataModel)
            }
        })
    }


    static func fetchAllDormData(dataModel: DataModel) {
        let colGroupQuery = db.collectionGroup("Info") // << collectionGroup ใช้ Info
        colGroupQuery.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching all Info documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No Info documents found.")
                return
            }
            var tempDormList: [Dormitory] = []
            for document in documents {
                let dormData = document.data()
                let dorm = Dormitory(
                    id: dormData["id"] as? String ?? "",
                    name: dormData["name"] as? String ?? "",
                    room: dormData["room"] as? String ?? "",
                    img: dormData["img"] as? String ?? "",
                    rent: dormData["rent"] as? Double ?? 0,
                    electricityBill: dormData["electricityBill"] as? Double ?? 0,
                    waterBill: dormData["waterBill"] as? Double ?? 0,
                    internetBill: dormData["internetBill"] as? Double ?? 0,
                    location: dormData["location"] as? String ?? "",
                    dormFree: dormData["dormFree"] as? String ?? "",
                    isFull: dormData["isFull"] as? Bool ?? false,
                    phoneNumber: dormData["phoneNumber"] as? String ?? "",
                    owner: dormData["owner"] as? String ?? ""
                )

                tempDormList.append(dorm)
            }

            DispatchQueue.main.async {
                dataModel.dormList = tempDormList
                print("✅ Fetch All Dormitories Success! Total: \(tempDormList.count) dormitories.")
            }
        }
    }

    
    static func fetchUser(dataModel: DataModel){
        let colGroupsQuery = db.collectionGroup("userInfo")
        colGroupsQuery.getDocuments{ (snapshot, error) in
            if let error = error {
                print("Error fetching all userInfo documents: \(error)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No userInfo documents found.")
                return
            }
            var tempUserList: [UserInfo] = []
            for document in documents {
                let userData = document.data()
                let user = UserInfo(id: userData["id"] as? String ?? "",
                    firstName: userData["firstname"] as? String ?? "", lastName: userData["lastname"] as? String ?? "", email: userData["email"] as? String ?? "", phone: userData["phone"] as? String ?? "", profileImage: userData["img"] as? String ?? "", isDormitory: userData["isDorm"] as? Bool ?? false, isAdmin: userData["isAdmin"] as? Bool ?? false
                )
                tempUserList.append(user)
            }
            DispatchQueue.main.async {
                dataModel.userList = tempUserList
                print("✅ Fetch All User Success! Total: \(tempUserList.count) account")
                
            }
        }
    }
    
    static func fetchDormInvite(dataModel: DataModel){
        dataModel.inviteList.removeAll()
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection("users").document(uid).collection("invite")

        colRef.getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            
            var tempList: [InviteModel] = []
            
            for document in QuerySnapshot!.documents {
                let inviteData = document.data()
                
                DispatchQueue.main.async {
                    var inviteTemp = InviteModel(dormId: inviteData["dormId"] as? String ?? "",userId: inviteData["userId"] as? String ?? "", dormName: inviteData["dormName"] as? String ?? "", invite: inviteData["invite"] as? Bool ?? false, room: inviteData["room"] as? Int ?? 0)
                    if(inviteTemp.invite){
                        tempList.append(inviteTemp)
                    }
                    print("✅ Fetch invite Success!! Found \(dataModel.inviteList.count)")
                }
                DispatchQueue.main.async {
                    dataModel.inviteList = tempList
                    print("✅ Fetch All Invite Success! Total: \(dataModel.inviteList.count) account")
                    
                }
            }
        }
    }
    
    static func fetchRoomUser(did: String, room: Int, dataModel: DataModel){
        let colRef = db.collection("dormitory").document(did).collection("Info")
        
        print("fetchRoomUser")
        colRef.getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in QuerySnapshot!.documents {
                let dormData = document.data()
                DispatchQueue.main.async {
                    var temp = Dormitory(id: dormData["id"] as? String ?? "", name: dormData["name"] as? String ?? "", room: dormData["room"] as? String ?? "", img: dormData["img"] as? String ?? "", rent: dormData["rent"] as? Double ?? 0, electricityBill: dormData["electricityBill"] as? Double ?? 0, waterBill: dormData["waterBill"] as? Double ?? 0, internetBill: dormData["internetBill"] as? Double ?? 0, location: dormData["location"] as? String ?? "", dormFree: dormData["dormFree"] as? String ?? "", isFull: dormData["isFull"] as? Bool ?? false, phoneNumber: dormData["phoneNumber"] as? String ?? "", owner: dormData["owner"] as? String ?? "")
                    dataModel.dorm = temp
                }
                DispatchQueue.main.async {
                    fetchUserRoomInfo(did: did, room: room, dataModel: dataModel )
                }
            }
        }
    }
    
    static func fetchUserRoomInfo(did: String,room: Int, dataModel: DataModel){
        let colRef = db.collection("dormitory").document(did).collection("Room").document("\(room)")
        colRef.getDocument{ (document, error) in
            if let error = error {
                print("Error fetching room info: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async{
                    let temp = RoomModel(
                        did: data?["did"] as? String ?? "",
                                        number: data?["number"] as? Int ?? 0,
                                        owner: data?["owner"] as? String ?? "",
                                        ownerUserId: data?["ownerUserId"] as? String ?? "",
                                        status: data?["status"] as? String ?? "",
                                        dateMoveIn: data?["dateMoveIn"] as? String ?? "",
                                        datePromise: data?["datePromise"] as? String ?? "",
                                        electricityUse: data?["electricityUse"] as? String ?? "",
                                        waterUse: data?["waterUse"] as? String ?? "",
                                        isOwn: data?["isOwn"] as? Bool ?? false,
                        isWaiting: data?["isWaiting"] as? Bool ?? false,
                        isWaitForPaid: data?["isWaitForPaid"] as? Bool ?? false)
                    dataModel.room = temp
                }
                DispatchQueue.main.async {
                    fetchBill(type: USER,dataModel: dataModel)
                }
            }
        }
    }
    
    static func fectVisitList(type: String, dataModel: DataModel) {
        dataModel.userVisitList.removeAll()
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection(type).document(uid).collection("Visit")
        colRef.getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            
            var tempList: [UserVisitModel] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                
                DispatchQueue.main.async {
                    var visitTemp = UserVisitModel(
                        uid: data["uid"] as? String ?? "",
                        did: data["did"] as? String ?? "",
                        dormName: data["dormName"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        phone: data["phone"] as? String ?? "",
                        date: data["date"] as? String ?? "",
                        isVisited: data["isVisited"] as? Bool ?? false)
                    tempList.append(visitTemp)
                }
                
                DispatchQueue.main.async {
                    dataModel.userVisitList = tempList
                    print("✅ Fetch All Visit Success! Total: \(dataModel.userVisitList.count) account")
                    
                }
            }
        }
    }
    
    static func fetchKeyToRoom(dataModel: DataModel){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection("users").document(uid).collection("dormInfo")
        
        colRef.getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in QuerySnapshot!.documents {
                let data = document.data()
                DispatchQueue.main.async {
                    dataModel.keyToDorm.did = data["did"] as? String ?? ""
                    dataModel.keyToDorm.room = data["room"] as? Int ?? 0
                }
                DispatchQueue.main.async{
                    fetchRoomUser(did: dataModel.keyToDorm.did, room: dataModel.keyToDorm.room, dataModel: dataModel)
                }
                
            }
            
        }
        
    }
    
    static func fetchBill(type: String,dataModel: DataModel){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection(type).document(uid).collection("Bill")
        
        colRef.getDocuments{ (querySnapshots, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            
            var tempPaidList: [BillModel] = []
            var tempNotPaidList: [BillModel] = []
            
            for document in querySnapshots!.documents {
                let data = document.data()
                DispatchQueue.main.async {
                    var temp = BillModel(did: data["did"] as? String ?? "",
                                         uid: data["uid"] as? String ?? "",
                                         name: data["name"] as? String ?? "",
                                         DateBill: data["DateBill"] as? String ?? "",
                                         DatePaidUntil: data["DatePaidUntil"] as? String ?? "",
                                         DatePaid: data["DatePaid"] as? String ?? "",
                                         Time: data["Time"] as? String ?? "",
                                         TimePaid: data["TimePaid"] as? String ?? "",
                                         Total: data["Total"] as? Double ?? 0,
                                         eleUnit: data["eleUnit"] as? Double ?? 0,
                                         eleUse: data["eleUse"] as? Double ?? 0,
                                         eleTotal: data["eleTotal"] as? Double ?? 0,
                                         waterUnit: data["waterUnit"] as? Double ?? 0,
                                         waterUse: data["waterUse"] as? Double ?? 0,
                                         waterTotal: data["waterTotal"] as? Double ?? 0,
                                         internet: data["internet"] as? Double ?? 0,
                                         rent: data["rent"] as? Double ?? 0,
                                         isPaid: data["isPaid"] as? Bool ?? false)
                    if(!temp.isPaid){
                        tempNotPaidList.append(temp)
                    }else{
                        tempPaidList.append(temp)
                    }
                }
                DispatchQueue.main.async {
                    dataModel.billNoti = tempNotPaidList
                    dataModel.billHistory = tempPaidList
                }
            }
            
        }
    }
    
    static func fetchReport(type: String, dataModel: DataModel){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let colRef = db.collection(type).document(uid).collection("Report")
        
        colRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            
            var tempResoveList : [ReportModel] = []
            var tempNotResoveList : [ReportModel] = []
            var tempList : [ReportModel] = []
            
            for document in snapshot!.documents {
                let data = document.data()
                DispatchQueue.main.async {
                    var temp = ReportModel(uid: data["uid"] as? String ?? "",
                                           did: data["did"] as? String ?? "",
                                           name: data["name"] as? String ?? "",
                                           room: data["room"] as? Int ?? 0,
                                           status: data["status"] as? String ?? "",
                                           detail: data["detail"] as? String ?? "",
                                           dateReport: data["dateReport"] as? String ?? "",
                                           timeReport: data["timeReport"] as? String ?? "",
                                           dateResolve: data["dateResolve"] as? String ?? "",
                                           timeResolve: data["timeResolve"] as? String ?? "",
                                           isResolve: data["isResolve"] as? Bool ?? false)
                    if(temp.isResolve){
                        tempResoveList.append(temp)
                    }else{
                        tempNotResoveList.append(temp)
                    }
                    tempList.append(temp)
                }
                DispatchQueue.main.async {
                    dataModel.reportResoveList = tempResoveList
                    dataModel.reportNotResoveList = tempNotResoveList
                    dataModel.reportList = tempList
                    print("report ทั้งหมด: \(dataModel.reportList.count)")
                }
            }
        }
    }
}

