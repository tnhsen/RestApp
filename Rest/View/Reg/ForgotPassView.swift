//
//  ForgotPassView.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//
import SwiftUI

struct ForgotPassView: View {
    
    @EnvironmentObject var dataModel : DataModel
    @State private var showAlert = false
    
    @State private var email: String = ""
    
    var body: some View {
        NavigationView(){
            GeometryReader { geometry in
                ZStack {
                    
                    Screen()
                    
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 10))
                        
                        Button(action: {
                            showAlert = true
                            
                        }) {
                            Text("Send Email")
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.6, height: 50)
                                .background(Color(hex: colorLevel1))
                                .cornerRadius(10)
                        }
                        .alert("ส่งอีเมลสำเร็จโปรดตรวจสอบอีเมลของคุณ", isPresented: $showAlert, actions: {
                            Button("ตกลง", role: .destructive) {
                                HelpMethods.sendResetPasswordEmail(email: email)
                                showAlert = false
                            }
                        })
                        
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
                
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct ForgotPassPreView: PreviewProvider {
    static var previews: some View {
        ForgotPassView()
    }
}
