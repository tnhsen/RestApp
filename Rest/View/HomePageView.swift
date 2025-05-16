//
//  HomePageView.swift
//  Rest
//
//  Created by Me Tomm on 28/3/2568 BE.
//

import SwiftUI

struct HomePageView: View {
    
    @EnvironmentObject var dataModel : DataModel
    
    var body: some View {
        
        Group{
            GeometryReader { geometry in
                ZStack {
                    
                    Screen()
                    
                    if dataModel.userInfo.isDormitory {
                        if dataModel.userInfo.isAdmin{
                            DormAdmin(dorm: dataModel.dorm)
                        }else{
                            Dorm(dormitory: dataModel.dorm, room: dataModel.room)
                        }
                    }else {
                        ZStack{
                            
                            NavigationLink(destination: SearchDormView()){
                                Label("ค้นหาหอพัก", systemImage: "magnifyingglass").position(x: geometry.size.width / 2, y: geometry.size.height / 6)
                            }.buttonStyle(.plain)
                            
                            VStack{
                                if(!dataModel.userInfo.isAdmin){
                                    if(dataModel.inviteList.isEmpty && dataModel.userVisitList.isEmpty){
                                        Image(systemName: "house").font(.system(size: 100))
                                            .padding()
                                            .foregroundColor(.gray)
                                        Text("คุณยังไม่ได้ลงทะเบียนหอพัก").foregroundColor(.gray)
                                    }else {
                                        
                                        ForEach(dataModel.inviteList){inv in
                                            InviteCard(invite: inv)
                                        }
                                        
                                        ForEach(dataModel.userVisitList){vis in
                                            VisitCard(visit: vis)
                                        }
                                        
                                    }
                                }else{
                                    Image(systemName: "house").font(.system(size: 100))
                                        .padding()
                                        .foregroundColor(.gray)
                                    Text("คุณยังไม่ได้ลงทะเบียนหอพัก").foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    
                    
                }
                
                
            }
        }.onAppear(){
                FetchData.fetchUserData(dataModel: dataModel)
            
            FetchData.fetchDormInvite(dataModel: dataModel)
            
            }
        .alert(isPresented: $dataModel.showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Your information has been saved."),
                            dismissButton: .default(Text("OK")) {
                                dataModel.showAlert = false
                                                                
                            }
                        )
                    }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView().environmentObject(DataModel())
    }
}
