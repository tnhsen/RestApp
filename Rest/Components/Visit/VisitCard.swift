//
//  inviteCard.swift
//  Rest
//
//  Created by Me Tomm on 9/5/2568 BE.
//

import SwiftUI

struct VisitCard: View{
    
    var visit: UserVisitModel
    
    var body: some View {
        HStack{
            Image(systemName: "house").font(.system(size: 35)).opacity(0.3)
            
            Text("คุณจองคิวเข้าชม \(visit.dormName)\nกรุณาไปตามเวลาที่นัดหมาย").multilineTextAlignment(.center).opacity(0.3)
        }
    }
}

struct VisitAdminCard: View {
    
    var visit: UserVisitModel
    
    var body: some View {
        NavigationLink(destination: VisitDetail(visite: visit)) {
            VStack(alignment: .leading, spacing: 10) {
                Text("แจ้งเข้าชมหอ").font(.title2).bold()
                
                HStack(spacing: 40) {
                    Text("วันที่: \(visit.date)")
                        .opacity(0.5)
                    
                    
                }
                
                Text("คุณมีคิวเข้าชมหอ \(visit.dormName) โดยผู้เข้าชื่อ \(visit.firstName) \(visit.lastName)")
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(5)
            .frame(width: 300, height: 110)
            .border(Color.black, width: 1)
        }
        .buttonStyle(.plain)
    }
}

struct VisitCard_Previews: PreviewProvider {
    static var previews: some View {
        VisitAdminCard(visit: DataModel().userVisitForm)
    }
}


