//
//  SearchUserView.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct SearchUserView: View {
    
    @EnvironmentObject var dataModel: DataModel
    var room: RoomModel
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                Screen2()
                
                ScrollView{
                    VStack{
                        TextField("Search dormitory", text: $dataModel.searchUser)
                            .frame(width: geometry.size.width / 1.6, height: geometry.size.height / 20)
                            .padding()
                            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                            .padding()
                        
                        ForEach(dataModel.userList.filter { user in

                            let searchText = dataModel.searchUser.lowercased()
                            let matchesSearch = searchText.isEmpty ||
                                user.firstName.lowercased().contains(searchText) ||
                                user.email.lowercased().contains(searchText) ||
                                user.phone.lowercased().contains(searchText)
                            
                            return matchesSearch && !user.isAdmin && !user.isDormitory
                        }) { dl in
                            UserCard(user: dl, room: room)
                        }
                    }
                }
                .frame(width: geometry.size.width * 0.8,
                       height: geometry.size.height * 0.8)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}


struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView(room: DataModel().room)
    }
}
