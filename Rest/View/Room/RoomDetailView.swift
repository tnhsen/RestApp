//
//  RoomViewCom.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct RoomDetailView: View {
    

    @EnvironmentObject var dataModel: DataModel
    
    var room: RoomModel
    
    var body: some View {
        Group{
            if(room.isOwn){
                RoomOwnView(room: room)
            }else{
                RoomNotOwnView(room: room)
            }
        }
        
    }
        

}

struct RoomViewCom_Previews: PreviewProvider {
    static var previews: some View {
        RoomDetailView(room: DataModel().room)
    }
}
