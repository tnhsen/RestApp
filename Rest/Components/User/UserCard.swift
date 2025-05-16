//
//  UserListCard.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct UserCard: View {
    
    var user: UserInfo
    
    @EnvironmentObject var dataModel: DataModel
    var room: RoomModel
    
    var body: some View {
        NavigationLink(destination: UserDatail(user: user, room: room)){
            HStack(spacing: 20){
                
                HStack{
                    ZStack{
                        
                        if let image = dataModel.selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                .shadow(radius: 5)
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.3)
                                .frame(width: 75)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .imageScale(.large)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        
                    }.padding()
                    
                    VStack {
                        Text("\(user.firstName) \(user.lastName)").font(.title3)
                        Text("\(user.email)")
                        Text("\(user.phone)")
                    }
                    
                    
                }
                
                Spacer()
                
            }.frame(width: 300, height: 100)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
        }.buttonStyle(.plain)
    }
}

struct UserListCard_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(user: DataModel().userInfo, room: DataModel().room).environmentObject(DataModel())
    }
}
