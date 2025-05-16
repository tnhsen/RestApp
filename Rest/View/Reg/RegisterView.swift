//
//  RegisterView.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var dataModel : DataModel
    
    var body: some View {
        if dataModel.isRegister {
            RegInfoView()
        }else{
            NavigationView(){
                GeometryReader { geometry in
                    ZStack {
                        
                        Screen()
                                    
                        VStack(spacing: 20) {
                            TextField("Email", text: $dataModel.user.email).keyboardType(.emailAddress)
                                .padding()
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                            
                            SecureField("Password", text: $dataModel.user.password)
                                .padding()
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                            
                            SecureField("Confirm Password", text: $dataModel.confirmPassword)
                                .padding()
                                .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                            
                            Button(action: {dataModel.register()}) {
                                Text("Register")
                                    .foregroundColor(.white)
                                    .frame(width: geometry.size.width * 0.6, height: 50)
                                    .background(Color(hex: colorLevel1))
                                    .cornerRadius(10)
                            }
                        }
                        .padding().frame(width: geometry.size.width * 0.8,
                                         height: geometry.size.height * 0.8)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        
                        HStack(){
                            NavigationLink(destination: LoginView()){
                                Text("Back to Login").foregroundStyle(Color(hex: colorLevel1)).font(.system(size: 12))
                            }.padding()
                            
                        }.position(x: geometry.size.width / 2 ,y: geometry.size.height - (geometry.size.height / 7))
                        
                    }
                    
                    
                    if (dataModel.isRegisterFail){
                        Text("Invalid password or email").foregroundStyle(Color.red).position(x: geometry.size.width / 2, y: geometry.size.height / 1.35)
                    }
                    
                }
            }.navigationBarBackButtonHidden(true)
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(DataModel())
    }
}
