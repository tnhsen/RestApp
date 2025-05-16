//
//  InfoAdminView.swift
//  Rest
//
//  Created by Me Tomm on 28/4/2568 BE.
//

import SwiftUI

struct InfoAdminView: View {
    @EnvironmentObject var dataModel: DataModel
    
    // กำหนด layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Screen()
                
                Text("ห้องทั้งหมด")
                    .font(.title)
                    .bold()
                    .padding(.top)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.height - 30))
                
                VStack {
                    
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(dataModel.roomList.sorted(by: { $0.number < $1.number })) { room in
                                Room(room: room)
                            }

                        }
                        .padding()
                    }.frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                }
            }
        }
    }
}


struct InfoAdminView_Previews: PreviewProvider {
    static var previews: some View {
        InfoAdminView().environmentObject(DataModel())
    }
}
