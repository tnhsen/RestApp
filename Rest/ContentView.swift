//
//  ContentView.swift
//  Rest
//
//  Created by student on 15/3/2568 BE.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataModel : DataModel
    
    var body: some View {
        Group {
            if dataModel.isLogin {
                MainView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            dataModel.checkLogin()
            
            dataModel.NavigateToMain = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataModel())
    }
}
