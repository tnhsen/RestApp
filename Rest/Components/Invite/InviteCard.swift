//
//  Untitled.swift
//  Rest
//
//  Created by Me Tomm on 30/4/2568 BE.
//


import SwiftUI

struct InviteCard: View {
    
    var invite: InviteModel
    
    var body: some View {
        NavigationLink(destination: InviteDetail(invite: invite)){
            HStack{
                Image(systemName: "house").font(.system(size: 35)).opacity(0.3)
                
                Text("มีคำเชิญเข้าร่วมหอพักจาก\n\(invite.dormName)").multilineTextAlignment(.center).opacity(0.3)
            }
        }.buttonStyle(.plain)
            .padding()
    }
}

/*
struct InviteCard_Previews: PreviewProvider {
    static var previews: some View {
        InviteCard(invite: DataModel().invite)
    }
}
*/
