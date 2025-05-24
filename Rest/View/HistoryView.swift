//
//  HistoryView.swift
//  Rest
//
//  Created by Me Tomm on 28/3/2568 BE.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var dataModel : DataModel
    @State private var selectedCategory: String = "บิล"
    @State private var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    let categories = ["บิล", "รายการปัญหา","สรุปผล"]
    
    var body: some View {
            
        Group{
            GeometryReader { geometry in
                ZStack {
                    
                    Screen()
                    
                    
                        if(dataModel.userInfo.isAdmin){
                            VStack{
                                Picker("บิล", selection: $selectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                
                                
                                ScrollView{
                                    VStack{
                                        if selectedCategory == "บิล" {
                                            ForEach(dataModel.billHistory.sorted(by: {pvs, nex in return convertDateTime(date: pvs.DatePaid, time: pvs.TimePaid) > convertDateTime(date: nex.DatePaid, time: nex.TimePaid)})) {bl in BillHistoryCard(bill: bl)}
                                        }else if(selectedCategory == "รายการปัญหา"){
                                            ForEach(dataModel.reportList){ rl in
                                                if(rl.isResolve){
                                                    ReportCard(report: rl)
                                                }
                                                    
                                            }
                                        }else if(selectedCategory == "สรุปผล"){
                                            DashboardCombinedView()
                                        }
                                        
                                        
                                    }.padding()
                                }
                                
                                .frame(width: geometry.size.width * 0.8,
                                        height: geometry.size.height * 0.8)
                                 .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5)
                            }
                            
                        }else{
                            ScrollView{
                                VStack{
                                    ForEach(dataModel.billHistory.sorted(by: {pvs, nex in return convertDateTime(date: pvs.DatePaid, time: pvs.TimePaid) > convertDateTime(date: nex.DatePaid, time: nex.TimePaid)})) {bl in BillHistoryCard(bill: bl)}
                                }.padding()
                            }
                            
                            .frame(width: geometry.size.width * 0.8,
                                    height: geometry.size.height * 0.8)
                             .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                        
                        
                    
                    
                }
                
                
            }
        }
        
    
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView().environmentObject(DataModel())
    }
}
