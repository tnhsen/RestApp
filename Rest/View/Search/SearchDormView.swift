//
//  SearchView.swift
//  Rest
//
//  Created by Me Tomm on 29/3/2568 BE.
//

import SwiftUI

struct SearchDormView: View {
    
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        
            GeometryReader {geometry in
                
                ZStack{
                    
                    Screen()
                    
                    ScrollView(){
                        
                        VStack{
                            TextField("Search dormitory", text: $dataModel.searchDormitory)
                                .frame(width: geometry.size.width / 1.6, height: geometry.size.height / 20)
                                .padding()
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                                .padding()
                            
                            
                            ForEach(dataModel.dormList.filter { dorm in
                                                    dataModel.searchDormitory.isEmpty || dorm.name.localizedCaseInsensitiveContains(dataModel.searchDormitory)
                                                }) { dl in
                                                    DormSearch(dorm: dl)
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchDormView().environmentObject(DataModel())
    }
}
