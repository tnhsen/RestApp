//
//  ProfileView.swift
//  Rest
//
//  Created by Me Tomm on 28/3/2568 BE.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var dataModel : DataModel
    @State private var showDeleteConfirm = false
    @State private var showAdminConfirm = false
    
    var body: some View {
        if dataModel.isLogin {
            
            Group{
                GeometryReader { geometry in
                    ZStack {
                        
                        Screen()
                        
                        Text("ข้อมูลส่วนตัว")
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 15)
                            .font(.title)
                            
                        
                        VStack(){
                            
                            if let image = dataModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                    .shadow(radius: 5)
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 100))
                                    .imageScale(.large)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            Text(dataModel.userInfo.firstName + "  "  + dataModel.userInfo.lastName).font(.title2)
                            
                            Text(verbatim: dataModel.userInfo.email)
                            
                            Text(verbatim: dataModel.userInfo.phone)
                         
                            
                            
                            if(dataModel.userInfo.isAdmin){
                                if(!dataModel.userInfo.isDormitory){
                                    NavigationLink(destination: DormFormView()){
                                        Text("จัดการหอพัก").foregroundColor(.white)
                                            .frame(width: geometry.size.width * 0.6, height: 50)
                                            .background(Color(hex: colorLevel1))
                                            .cornerRadius(10)
                                    }.padding()
                                }else{
                                    NavigationLink(destination: EditDormFormView()){
                                        Text("จัดการหอพัก").foregroundColor(.white)
                                            .frame(width: geometry.size.width * 0.6, height: 50)
                                            .background(Color(hex: colorLevel1))
                                            .cornerRadius(10)
                                    }.padding()
                                }
                            }
                        }
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.6)
                        
                        
                        HStack{
                            NavigationLink(destination: EditProfileView()){
                                    Text("Edit Profile")
                            }.padding()
                                .buttonStyle(.plain)
                            
                            Text("|").padding()
                            
                            Button(action: {dataModel.logout()}){
                                Text("Logout")
                            }.padding()
                                .buttonStyle(.plain)
                        }.position( x: geometry.size.width / 2 , y: geometry.size.height - (geometry.size.height / 7) )
                        
                        
                    }
                    if dataModel.userInfo.isAdmin {
                        if (dataModel.userInfo.isDormitory){
                            Button(action: {
                                showDeleteConfirm = true
                            }) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.red)
                                .padding()
                            }
                            .alert("คุณแน่ใจหรือไม่ว่าต้องการลบหอพักนี้?", isPresented: $showDeleteConfirm, actions: {
                                Button("ลบ", role: .destructive) {
                                    dataModel.deleteDorm()
                                    showDeleteConfirm = false
                                }
                                Button("ยกเลิก", role: .cancel) {
                                    showDeleteConfirm = false
                                }
                            })
                        }
                    }else{
                        Button(action: {
                            showAdminConfirm = true
                        }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                            .padding()
                        }
                        .alert("คุณแน่ใจหรือไม่ว่าต้องเปลี่ยนเป็นผู้ดูแลหอพัก", isPresented: $showAdminConfirm, actions: {
                            Button("เปลี่ยน", role: .destructive) {
                                dataModel.changeToAdmin()
                                showAdminConfirm = false
                            }
                            Button("ยกเลิก", role: .cancel) {
                                showAdminConfirm = false
                            }
                            })
                    }
                    
                    
                }
            }.onAppear(){
                FetchData.fetchData(dataModel: dataModel)
            }
            
        }else{
            LoginView()
        }
        
        
        
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(DataModel())
    }
}
