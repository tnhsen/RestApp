//
//  LoginView.swift
//  Rest
//
//  Created by student on 15/3/2568 BE.
//
import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        NavigationView(){
            GeometryReader { geometry in
                ZStack {
                    
                    Screen()
                                
                    VStack(spacing: 20) {
                        TextField("Email", text: $dataModel.user.email)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        
                        SecureField("Password", text: $dataModel.user.password)
                            .padding()
                            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        
                        Button(action: {dataModel.login()}) {
                            Text("Login")
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
                        NavigationLink(destination: RegisterView()){
                            Text("Register").foregroundStyle(Color(hex: colorLevel1)).font(.system(size: 12))
                        }.padding()
                        Text("|").foregroundStyle(Color(hex: colorLevel1))
                        NavigationLink(destination: ForgotPassView()){
                            Text("Forgot Password?").foregroundStyle(Color.gray).font(.system(size: 12))
                        }.padding()
                        
                    }.position(x: geometry.size.width / 2 ,y: geometry.size.height - (geometry.size.height / 7))
                    
                    if dataModel.isLoginFail{
                        
                        Text("Invalid password or email").foregroundStyle(Color.red).position(x: geometry.size.width / 2, y: geometry.size.height / 1.4)
                    }
                }
                
                
            }
        }.navigationBarBackButtonHidden(true)
            .onAppear(){
                DataModel().NavigateToMain = false
                
                DataModel().isRegister = false
                DataModel().isRegisterFail = false
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(DataModel())
    }
}
