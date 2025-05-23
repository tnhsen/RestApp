//
//  DataModel.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth

final class DataModel: ObservableObject {
    @Published var confirmPassword: String = ""
    @Published var isLogin: Bool = false
    @Published var isLoginFail: Bool = false
    @Published var isRegister: Bool = false
    @Published var isRegisterFail: Bool = false
    @Published var searchDormitory: String = ""
    @Published var searchUser: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var showAlert : Bool = false
    @Published var alertStatus = ""
    @Published var alertDetail = ""
    @Published var NavigateToMain: Bool = false
    @Published var dormList: [Dormitory] = []
    @Published var roomList: [RoomModel] = []
    @Published var roomFree: [RoomModel] = []
    @Published var userList: [UserInfo] = []
    @Published var inviteList: [InviteModel] = []
    @Published var userVisitList: [UserVisitModel] = []
    @Published var roomOwnList: [RoomModel] = []
    @Published var billNoti: [BillModel] = []
    @Published var billHistory: [BillModel] = []
    @Published var reportNotResoveList: [ReportModel] = []
    @Published var reportResoveList: [ReportModel] = []
    @Published var reportList: [ReportModel] = []
    @Published var chatList: [ChatMetaModel] = []
    @Published var chatMessage: [String: [ChatModel]] = [:]
    
    
    @Published var dashBoard = DashboardModel(totalBill: 0, eleUse: 0, eleTotal: 0, waterUse: 0, waterTotal: 0, internet: 0, rent: 0, userIndorm: 0, totalReport: 0, resloveReport: 0)
    @Published var report = ReportModel(uid: "", did: "", name: "", room: 0, status: "", detail: "", dateReport: "", timeReport: "", dateResolve: "", timeResolve: "", isResolve: false)
    @Published var keyToDorm = KeyToDorm(did: "", room: 0)
    @Published var user = User(email: "", password: "")
    @Published var userInfo = UserInfo(id: "", firstName: "", lastName: "", email: "", phone: "", profileImage: "", isDormitory: false, isAdmin: false)
    @Published var dorm = Dormitory(id: "",name: "", room: "", img: "", rent: 0, electricityBill: 0, waterBill: 0, internetBill: 0, location: "", dormFree: "", isFull: false, phoneNumber: "", owner: "")
    @Published var room = RoomModel(did: "", number: 0, owner: "", ownerUserId: "", status: "", dateMoveIn: "", datePromise: "", electricityUse: "", waterUse: "", isOwn: false, isWaiting: false, isWaitForPaid: false)
    @Published var invite = InviteModel(dormId: "", userId: "", dormName: "", invite: false, room: 0)
    @Published var userVisitForm = UserVisitModel(uid: "", did: "", dormName: "", firstName: "", lastName: "", email: "", phone: "", date: "", isVisited: false)
    @Published var bill = BillModel(did: "", uid: "", name: "", DateBill: "", DatePaidUntil: "", DatePaid: "", Time: "",TimePaid: "", Total: 0, eleUnit: 0, eleUse: 0, eleTotal: 0, waterUnit: 0, waterUse: 0, waterTotal: 0, internet: 0, rent: 0, isPaid: false)
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    // Auth func
    func checkLogin(){
        let currentUser = auth.currentUser
        if currentUser != nil{
            isLogin = true
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: user.email, password: user.password){ authResuth, error in
            if let error = error{
                self.isLoginFail = true
                print("email: \(self.user.email),password: \(self.user.password)")
                print("Login Fail: \(error.localizedDescription)")
            }else{
                self.isLoginFail = false
                self.isLogin = true
                print("Login Success!")
            }
        }
    }
    
    func logout() {
        if auth.currentUser != nil {
            do {
                clearData()
                try auth.signOut()
                self.isLogin = false
                self.isLoginFail = false
                print("Logout Success!")
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }
    }
    
    func register(){
        if isValidInput(email: user.email, password: user.password){
            if(user.password == confirmPassword){
                auth.createUser(withEmail: user.email, password: user.password) { authResult, error in
                    if let error = error {
                        self.isRegisterFail = true
                        print("Error creating user: \(error)")
                    }else{
                        self.isRegisterFail = false
                        self.isRegister = true
                        print("Register Success!")
                    }
                }
            }else{
                self.isRegisterFail = true
            }
        }else{
            isRegisterFail = true
        }
    }
    
    // Picture func
    func selectProfileImage(_ newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data){
                DispatchQueue.main.async{
                    self.selectedImage = uiImage
                }
            }
        }
    }
    
    
    func deleteUserDormInfo(uid: String){
        let db = Firestore.firestore()
        let dormRef = db.collection("users").document(uid)
        
        dormRef.collection("Bill").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching bills: \(error)")
                return
            }
            
            let batch = db.batch()
            snapshot?.documents.forEach { doc in
                batch.deleteDocument(doc.reference)
            }
            
            batch.commit { err in
                if let err = err {
                    print("❌ Error deleting bills: \(err)")
                    return
                }
                
                print("Delete Bills")
                
                dormRef.collection("Report").getDocuments { snapshot2, error2 in
                    if let error2 = error2 {
                        print("❌ Error fetching report: \(error2)")
                        return
                    }
                    
                    let batch2 = db.batch()
                    snapshot2?.documents.forEach { doc in
                        batch.deleteDocument(doc.reference)
                    }
                    
                    batch2.commit { err2 in
                        if let err2 = err2 {
                            print("❌ Error deleting report: \(err2)")
                            return
                        }
                        
                        print("Delete report")
                        
                        dormRef.collection("dormInfo").getDocuments { snapshot3, error3 in
                            if let error3 = error3 {
                                print("❌ Error fetching dormInfo: \(error3)")
                                return
                            }
                            
                            let batch3 = db.batch()
                            snapshot3?.documents.forEach { doc in
                                batch3.deleteDocument(doc.reference)
                            }
                            
                            batch3.commit { err3 in
                                if let err3 = err3 {
                                    print("❌ Error deleting dormInfo: \(err3)")
                                    return
                                }
                                
                                print("Delete dormInfo")
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }

    func deleteDormWithSubcollections(uid: String) {
        let db = Firestore.firestore()
        let dormRef = db.collection("dormitory").document(uid)
        
        dormRef.collection("Room").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching rooms: \(error)")
                return
            }
            
            let batch = db.batch()
            snapshot?.documents.forEach { doc in
                batch.deleteDocument(doc.reference)
            }
            
            batch.commit { err in
                if let err = err {
                    print("❌ Error deleting rooms: \(err)")
                    return
                }
                
                print("✅ Deleted rooms")
                
                dormRef.collection("Bill").getDocuments { snapshot2, error2 in
                    if let error2 = error2 {
                        print("❌ Error fetching images: \(error2)")
                        return
                    }
                    
                    let batch2 = db.batch()
                    snapshot2?.documents.forEach { doc in
                        batch2.deleteDocument(doc.reference)
                    }
                    
                    batch2.commit { err2 in
                        if let err2 = err2 {
                            print("❌ Error deleting images: \(err2)")
                            return
                        }
                        
                        print("✅ Deleted images")
                        
                        dormRef.collection("Report").getDocuments { snapshot3, err3 in
                        
                            if let err3 = err3{
                                print("error to delete report")
                                return
                            }
                            
                            let batch3 = db.batch()
                            snapshot3?.documents.forEach { doc in
                            
                                batch3.deleteDocument(doc.reference)
                            }
                            
                            batch3.commit { error3 in
                            
                                if let error3 = error3 {
                                    print("❌ Error deleting report: \(error3)")
                                }
                                
                                print("Delete Report!")
                                
                                dormRef.collection("Visit").getDocuments { snapshop4, error4 in
                                
                                    if let error4 = error4 {
                                        print("error to delete visit")
                                        return
                                    }
                                    
                                    let batch4 = db.batch()
                                    snapshop4?.documents.forEach{ doc in
                                    
                                        batch4.deleteDocument(doc.reference)
                                    }
                                    
                                    batch4.commit { err4 in
                                    
                                        if let err4 = err4{
                                            print("error to delete visit")
                                        }
                                        
                                        print("Delete visit")
                                        
                                        dormRef.collection("Info").getDocuments { snapshot5, error5 in
                                            
                                            if let error5 = error5 {
                                                print("error to delete Info")
                                                return
                                            }
                                            
                                            let batch5 = db.batch()
                                            snapshot5?.documents.forEach{ doc in
                                                
                                                batch5.deleteDocument(doc.reference)
                                            }
                                            
                                            batch5.commit { err5 in
                                                
                                                if let err5 = err5{
                                                    print("error to delete info")
                                                }
                                                
                                                print("Delete info")
                                                
                                                dormRef.delete { error in
                                                    if let error = error {
                                                        print("❌ Error deleting dorm document: \(error)")
                                                    } else {
                                                        print("✅ Deleted dorm document")
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        

                    }
                }
            }
        }
    }

    
    
    func deleteDorm(){
        let data: [String: Any] = [
            "isDorm": false
        ]
        deleteDormWithSubcollections(uid: userInfo.id)
        UserMethods.updateUserInfo(uid: userInfo.id, col: "userInfo", data: data)
    }

    func changeToAdmin(){
        let data: [String: Any] = [
            "isAdmin": true
        ]
        UserMethods.updateUserInfo(uid: userInfo.id, col: "userInfo", data: data)
    }
    
    func deleteUserFromRoom(room: RoomModel){
        let dataDorm: [String: Any] = [
            "did": room.did,
            "number": room.number,
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
        let dataUser: [String: Any] = [
            "isDorm": false
        ]
        deleteUserDormInfo(uid: room.ownerUserId)
        AdminMethods.updateRoomData(did: room.did, room: room.number, data: dataDorm)
        UserMethods.updateUserInfo(uid: room.ownerUserId, col: "userInfo", data: dataUser)
        ChatMethods.addChat(senderUID: room.did, senderName: getName(), receiverUID: room.ownerUserId, username: room.owner, message: "ลาก่อน ขอให้โชคดี")
        
    }
    
    func calDashboardForMonth(month: Date) -> DashboardModel {
        var dashboard = DashboardModel(totalBill: 0, eleUse: 0, eleTotal: 0, waterUse: 0, waterTotal: 0, internet: 0, rent: 0, userIndorm: 0, totalReport: 0, resloveReport: 0)
        let calendar = Calendar.current

        let billsInMonth = billHistory.filter {
            calendar.isDate(convertDateTime(date: $0.DateBill, time: $0.Time), equalTo: month, toGranularity: .month)
        }

        let reportsInMonth = reportList.filter {
            calendar.isDate(convertDateTime(date: $0.dateReport, time: $0.timeReport), equalTo: month, toGranularity: .month)
        }

        for b in billsInMonth {
            dashboard.totalBill += b.Total
            dashboard.eleUse += b.eleUse
            dashboard.eleTotal += b.eleTotal
            dashboard.waterUse += b.waterUse
            dashboard.waterTotal += b.waterTotal
            dashboard.internet += b.internet
            dashboard.rent += b.rent
        }

        dashboard.userIndorm = roomOwnList.count
        dashboard.totalReport = reportsInMonth.count
        dashboard.resloveReport = reportsInMonth.filter({ $0.isResolve }).count

        return dashboard
    }

    
    func calDashboardTotal() {
        var totalBill: Double = 0
        var eleUse: Double = 0
        var eleTotal: Double = 0
        var waterUse: Double = 0
        var waterTotal: Double = 0
        var internet: Double = 0
        var rent: Double = 0

        for b in billHistory {
            totalBill += b.Total
            eleUse += b.eleUse
            eleTotal += b.eleTotal
            waterUse += b.waterUse
            waterTotal += b.waterTotal
            internet += b.internet
            rent += b.rent
        }

        dashBoard.totalBill = totalBill
        dashBoard.eleUse = eleUse
        dashBoard.eleTotal = eleTotal
        dashBoard.waterUse = waterUse
        dashBoard.waterTotal = waterTotal
        dashBoard.internet = internet
        dashBoard.rent = rent
        dashBoard.userIndorm = roomOwnList.count
        dashBoard.totalReport = reportList.count
        dashBoard.resloveReport = reportList.filter({ $0.isResolve }).count
    }

    
    func calDashBoard(){
        calDashboardTotal()
    }
    
    
    // Specify func
    func resoveReport(uid: String, did: String, report: ReportModel){
        let data: [String : Any] = [
            "dateResolve": getDateNow(),
            "timeResolve": getTimeNow(),
            "isResolve": true,
        ]
        AdminMethods.updateDormInfoMatch(did: did, col: "Report", matchField: "timeReport", matchValue: report.timeReport, newData: data)
        UserMethods.updateUserInfoMatch(uid: uid, col: "Report", matchField: "timeReport", matchValue: report.timeReport, newData: data)
        ChatMethods.addChat(senderUID: did, senderName: getName(), receiverUID: uid, username: report.name, message: "ฉันแก้ปัญหาให้แล้ว")
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func updateStatus(text: String, room: RoomModel){
        let data: [String: Any] = ["status": text]
        AdminMethods.updateRoomData(did: room.did, room: room.number, data: data)
        ChatMethods.addChat(senderUID: room.did, senderName: getName(), receiverUID: room.ownerUserId,username: room.owner, message: "สถานะห้องตอนนี้คือ: \(text)")
        FetchData.fetchData(dataModel: self)
    }
    
    func Report(status: String, detail: String){
        let data: [String: Any] = [
            "uid": userInfo.id,
            "did": keyToDorm.did,
            "name": getName(),
            "room": keyToDorm.room,
            "status": status,
            "detail": detail,
            "dateReport": getDateNow(),
            "timeReport": getTimeNow(),
            "dateResolve": "",
            "timeResolve": "",
            "isResolve": false
        ]
        
        AdminMethods.addDormInfo(did: keyToDorm.did, col: "Report", data: data)
        UserMethods.addUserInfo(uid: userInfo.id, col: "Report", data: data)
        ChatMethods.addChat(senderUID: userInfo.id, senderName: getName(), receiverUID: keyToDorm.did, username: getName(), message: "มีการแจ้งปัญหาครั้งใหม๋")
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func PaidBill(bill: BillModel){
        var updateBill: [String: Any] = [
            "did": bill.did,
            "uid": bill.uid,
            "name": bill.name,
            "DateBill": bill.DateBill,
            "DatePaidUntil": bill.DatePaidUntil,
            "DatePaid": getDateNow(),
            "Time": bill.Time,
            "TimePaid": getTimeNow(),
            "Total": bill.Total,
            "eleUnit": bill.eleUnit,
            "eleUse": bill.eleUse,
            "eleTotal": bill.eleTotal,
            "waterUnit": bill.waterUnit,
            "waterUse": bill.waterUse,
            "waterTotal": bill.waterTotal,
            "internet": bill.internet,
            "rent": bill.rent,
            "isPaid" : true
        ]
        var updateRoomBill: [String: Any] = [
            "electricityUse" : "0",
            "waterUse" : "0",
            "isWaitForPaid" : false
        ]
        
        
        UserMethods.updateUserInfoMatch(uid: bill.uid, col: "Bill", matchField: "Time", matchValue: bill.Time, newData: updateBill)
        AdminMethods.addDormInfo(did: bill.did, col: "Bill", data: updateBill)
        AdminMethods.updateRoomData(did: bill.did, room: room.number, data: updateRoomBill)
        ChatMethods.addChat(senderUID: bill.uid, senderName: bill.name, receiverUID: bill.did, username: bill.name, message: "มีการชำระค่าหอครั้งใหม่")
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func UpdateAllBill(){
        for r in roomOwnList{
            var eleUse: Double = Double(r.electricityUse) ?? 1
            var waterUse: Double = Double(r.waterUse) ?? 1
            var updateData: [String : Any] = [
                "electricityUse" : "\(eleUse)",
                "waterUse" : "\(waterUse)",
                "isWaitForPaid" : true
            ]
            let bill: [String: Any] = [
                "did": r.did,
                "uid": r.ownerUserId,
                "name": r.owner,
                "DateBill": getDateNow(),
                "DatePaidUntil": getDateFutureDay(day: 5),
                "DatePaid": "",
                "Time": getTimeNow(),
                "TimePaid": "",
                "Total": (dorm.electricityBill * eleUse) + (dorm.waterBill * waterUse) + (dorm.internetBill) + dorm.rent,
                "eleUnit": dorm.electricityBill,
                "eleUse": eleUse,
                "eleTotal": eleUse * dorm.electricityBill,
                "waterUnit": dorm.waterBill,
                "waterUse": waterUse,
                "waterTotal": waterUse * dorm.waterBill,
                "internet": dorm.internetBill,
                "rent": dorm.rent,
                "isPaid": false
            ]
            AdminMethods.updateRoomData(did: r.did, room: r.number, data: updateData)
            UserMethods.addUserInfo(uid: r.ownerUserId, col: "Bill", data: bill)
            ChatMethods.addChat(senderUID: r.did, senderName: getName(), receiverUID: r.ownerUserId, username: r.owner, message: "มีการแจ้งค่าหอครั้งใหม่")
            HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
        }
    }
    
    func UpdateBill(ele: Double, water : Double, room: RoomModel){
        let bill: [String : Any] = [
            "electricityUse" : "\(ele)",
            "waterUse" : "\(water)",
        ]
        AdminMethods.updateRoomData(did: room.did, room: room.number, data: bill)
        ChatMethods.addChat(senderUID: room.did, senderName: getName(), receiverUID: room.ownerUserId, username: room.owner, message: "ฉันได้อัพเดทค่าหอ")
    }
    
    func regInfo(){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let data: [String: Any] = [
            "firstname": userInfo.firstName,
            "lastname": userInfo.lastName,
            "phone": userInfo.phone,
            "img": userInfo.profileImage,
            "isDorm": userInfo.isDormitory,
            "isAdmin": userInfo.isAdmin,
            "id": uid,
            "email": getUserEmail()
        ]
        UserMethods.addUserInfo(uid: uid, col: "userInfo", data: data)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func updateInfo() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let updatedData: [String: Any] = [
            "firstname": self.userInfo.firstName,
            "lastname": self.userInfo.lastName,
            "phone": self.userInfo.phone,
            "img": self.userInfo.profileImage,
            "isDorm": self.userInfo.isDormitory,
            "isAdmin": self.userInfo.isAdmin
        ]
        UserMethods.updateUserInfo(uid: uid, col: "userInfo", data: updatedData)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func addDorm() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let data: [String: Any] = [
            "id": uid,
            "name": dorm.name,
            "room": dorm.room,
            "img": dorm.img,
            "rent": dorm.rent,
            "electricityBill": dorm.electricityBill,
            "waterBill": dorm.waterBill,
            "internetBill": dorm.internetBill,
            "location": dorm.location,
            "dormFree": dorm.room,
            "isFull": dorm.isFull,
            "phoneNumber": dorm.phoneNumber,
            "owner": getUserEmail()
        ]
        AdminMethods.addDormInfo(did: uid, col: "Info", data: data)
        UserMethods.updateUserInfo(uid: uid,col: "userInfo", data: ["isDorm": true])
        AdminMethods.createRoom(room: dorm.room, did: uid);
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func updateDorm(){
        guard let currentUser = Auth.auth().currentUser else { return }
        let uid = currentUser.uid
        let updatedData: [String: Any] = [
            "name": self.dorm.name,
            "room": self.dorm.room,
            "img": self.dorm.img,
            "rent": self.dorm.rent,
            "electricityBill": self.dorm.electricityBill,
            "waterBill": self.dorm.waterBill,
            "internetBill": self.dorm.internetBill,
            "location": self.dorm.location,
            "dormFree": self.dorm.dormFree,
            "isFull": self.dorm.isFull,
            "phoneNumber": self.dorm.phoneNumber,
            "owner": self.dorm.owner
        ]
        AdminMethods.updateDorm(did: uid,col: "Info", data: updatedData)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func inviteUserToDorm(user: UserInfo, dorm: Dormitory, room: RoomModel ){
        AdminMethods.inviteUser(user: user, room: room, dorm: dorm)
        AdminMethods.updateRoomData(did: dorm.id , room: room.number, data: ["isWaiting": true])
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func acceptDormInvite(invite: InviteModel){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let roomData : [String : Any] = [
            "owner": "\(self.userInfo.firstName) \(self.userInfo.lastName)",
            "ownerUserId": uid,
            "status": "normal",
            "dateMoveIn": getDateNow(),
            "datePromise": getDateFuture(month: 3),
            "electricityUse": "0",
            "waterUse": "0",
            "isOwn": true
        ]
        AdminMethods.updateRoomData(did: invite.dormId, room: invite.room, data: roomData)
        UserMethods.deleteUserInfo(uid: invite.userId, col: UserMethods.INVITE_COL)
        UserMethods.updateUserInfo(uid: uid, col: UserMethods.INFO_COL, data: ["isDorm": true])
        addRoomInfoToUser(uid: invite.userId, did: invite.dormId, invaite: invite)
        ChatMethods.addChat(senderUID: uid, senderName: getName(), receiverUID: invite.dormId, username: getName(), message: "สวัสดี ฉันคือสมาชิกใหม่ในหอคุณ")
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func userDenyInvite(invite: InviteModel){
        AdminMethods.updateRoomData(did: invite.dormId, room: invite.room, data: ["isWaiting" : false])
        UserMethods.deleteUserInfo(uid: invite.userId, col: UserMethods.INVITE_COL)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func addRoomInfoToUser(uid: String, did: String, invaite: InviteModel){
        let dormData: [String: Any] = [
            "did" : did,
            "room": invaite.room,
        ]
        UserMethods.addUserInfo(uid: uid, col: "dormInfo", data: dormData)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func userVisitDorm(visit: UserVisitModel){
        if(visit.date == ""){
            HelpMethods.showAlert(status: HelpMethods.failedStatus, dataModel: self)
            return
        }
        let data: [String: Any] = [
            "uid": visit.uid,
            "did": visit.did,
            "dormName": visit.dormName,
            "firstName": visit.firstName,
            "lastName": visit.lastName,
            "email": visit.email,
            "phone": visit.phone,
            "date": visit.date,
            "isVisited": false
        ]
        AdminMethods.addDormInfo(did: visit.did, col: "Visit", data: data)
        UserMethods.addUserInfo(uid: visit.uid, col: "Visit", data: data)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    func deleteVisitDorm(visit: UserVisitModel){
        UserMethods.deleteUserInfo(uid: visit.uid, col: UserMethods.VISIT_COL)
        AdminMethods.deleteDormVisite(did: visit.did, col: AdminMethods.VISIT_COL, uid: visit.uid)
        HelpMethods.showAlert(status: HelpMethods.successStatus, dataModel: self)
    }
    
    // Data func
    func clearData() {
        confirmPassword = ""
        isLogin = false
        isLoginFail = false
        isRegister = false
        isRegisterFail = false
        searchDormitory = ""
        searchUser = ""
        selectedImage = nil
        selectedItem = nil
        showAlert = false
        alertStatus = ""
        alertDetail = ""
        NavigateToMain = false

        dormList = []
        roomList = []
        roomFree = []
        userList = []
        inviteList = []
        userVisitList = []
        roomOwnList = []
        billNoti = []
        billHistory = []
        reportNotResoveList = []
        reportResoveList = []
        reportList = []
        chatList = []
        chatMessage = [:]

        report = ReportModel(uid: "", did: "", name: "", room: 0, status: "", detail: "", dateReport: "", timeReport: "", dateResolve: "", timeResolve: "", isResolve: false)
        keyToDorm = KeyToDorm(did: "", room: 0)
        user = User(email: "", password: "")
        userInfo = UserInfo(id: "", firstName: "", lastName: "", email: "", phone: "", profileImage: "", isDormitory: false, isAdmin: false)
        dorm = Dormitory(id: "", name: "", room: "", img: "", rent: 0, electricityBill: 0, waterBill: 0, internetBill: 0, location: "", dormFree: "", isFull: false, phoneNumber: "", owner: "")
        room = RoomModel(did: "", number: 0, owner: "", ownerUserId: "", status: "", dateMoveIn: "", datePromise: "", electricityUse: "", waterUse: "", isOwn: false, isWaiting: false, isWaitForPaid: false)
        invite = InviteModel(dormId: "", userId: "", dormName: "", invite: false, room: 0)
        userVisitForm = UserVisitModel(uid: "", did: "", dormName: "", firstName: "", lastName: "", email: "", phone: "", date: "", isVisited: false)
        bill = BillModel(did: "", uid: "", name: "", DateBill: "", DatePaidUntil: "", DatePaid: "", Time: "", TimePaid: "", Total: 0, eleUnit: 0, eleUse: 0, eleTotal: 0, waterUnit: 0, waterUse: 0, waterTotal: 0, internet: 0, rent: 0, isPaid: false)
    }

    
    func formGetInfo(dorm: Dormitory){
        guard let currentUser = Auth.auth().currentUser else { return }
        self.userVisitForm.uid = currentUser.uid
        self.userVisitForm.did = dorm.id
        self.userVisitForm.dormName = dorm.name
        self.userVisitForm.firstName = self.userInfo.firstName
        self.userVisitForm.lastName = self.userInfo.lastName
        self.userVisitForm.email = self.userInfo.email
        self.userVisitForm.phone = self.userInfo.phone
        self.userVisitForm.isVisited = false
    }
    
    func getUserEmail() -> String {
        return Auth.auth().currentUser!.email ?? ""
    }
    
    func getName () -> String {
        return userInfo.firstName + " " + userInfo.lastName
    }
}
            
            
            
                
            
                
        
    

