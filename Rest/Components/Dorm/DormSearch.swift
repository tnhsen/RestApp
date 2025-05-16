//
//  DormSearch.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct DormSearch: View {
    
    var dorm: Dormitory
    
    var body: some View {
        NavigationLink(destination: DormInfoView(dorm: dorm)){
            HStack(spacing: 20){
                if dorm.img == "" {
                    Image(systemName: "house").font(Font.system(size: 35)).frame(width: 50, height: 50).border(Color.black, width: 1)
                        .padding()
                }else {
                    Image(systemName: "house").font(Font.system(size: 35)).frame(width: 50, height: 50).border(Color.black, width: 1)
                        .padding()
                }
                
                VStack(alignment: .leading){
                    Text(dorm.name).font(.title2)
                    
                    var rent = String(format: "%.f", dorm.rent)
                    Text(rent + " บาท/เดือน")
                }
                
                if dorm.isFull {
                    Circle().fill(Color.red).frame(width: 15, height: 15)
                }else{
                    Circle().fill(Color.green).frame(width: 15, height: 15)
                }
            }
            .frame(width: 300, height: 110, alignment: .leading)
            .border(Color.black, width: 1)
            .padding(5)
        }
    }
}

struct DormSearch_Previews: PreviewProvider {
    static var previews: some View {
        DormSearch(dorm: DataModel().dorm)   }
}
