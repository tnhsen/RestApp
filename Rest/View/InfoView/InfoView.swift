//
//  InfoView.swift
//  Rest
//
//  Created by Me Tomm on 28/3/2568 BE.
//

import SwiftUI

struct InfoView: View {
    
    @EnvironmentObject var dataModel : DataModel
    var body: some View {
        Group{
            if dataModel.userInfo.isDormitory{
                if(dataModel.userInfo.isAdmin){
                    InfoAdminView()
                }else{
                    InfoUserView()
                }
            }else{
                Screen()
            }
        }.onAppear(){
            FetchData.fetchData(dataModel: dataModel)
        }
        /*
        GeometryReader { geometry in
            ZStack {
                    
                Screen()
                    
            }
                
            
        }
         */
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView().environmentObject(DataModel())
    }
}
