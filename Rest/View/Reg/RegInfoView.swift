
//
//  RegInfoView.swift
//  Rest
//
//  Created by Me Tomm on 25/4/2568 BE.
//

import SwiftUI
import PhotosUI

struct RegInfoView: View {
    
    @EnvironmentObject var dataModel : DataModel
    
    var body: some View {
        if dataModel.NavigateToMain {
            MainView()
        }else{
            NavigationView {
                GeometryReader { geometry in
                    ZStack {
                        
                        Screen()
                        
                        VStack(spacing: 20){

                            Text("Input your infomation").font(.title)
                            
                            VStack {
                                PhotosPicker(selection: $dataModel.selectedItem, matching: .images, photoLibrary: .shared()) {
                                    if let image = dataModel.selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                                            .shadow(radius: 5)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 100))
                                            .imageScale(.large)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                }
                                .onChange(of: dataModel.selectedItem) { newItem in
                                    dataModel.selectProfileImage(newItem)
                                }
                                
                            }
                            HStack(spacing: 10) {
                                TextField("First Name", text: $dataModel.userInfo.firstName)
                                    .padding()
                                    .frame(width: 150, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    .multilineTextAlignment(.center)
                                
                                TextField("Last Name", text: $dataModel.userInfo.lastName)
                                    .padding()
                                    .frame(width: 150, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                    .multilineTextAlignment(.center)
                            }
                            
                            TextField("Phone", text: $dataModel.userInfo.phone)
                                .padding()
                                .frame(width: 310 ,height: 40)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                .multilineTextAlignment(.center)
                            
                            Button("Save"){
                                dataModel.regInfo()
                            }.foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.6, height: 50)
                                .background(Color(hex: colorLevel1))
                                .cornerRadius(10).padding()
                            
                        }.padding().frame(width: geometry.size.width * 0.8,
                                          height: geometry.size.height * 0.8)
                         .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    }
                }
            }.navigationBarBackButtonHidden(true)
            .alert(isPresented: $dataModel.showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Your information has been saved."),
                                dismissButton: .default(Text("OK")) {
                                    dataModel.isLogin = true
                                    dataModel.NavigateToMain = true
                                    dataModel.isRegister = false
                                }
                            )
                        }
        }
    }
}

struct RegInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RegInfoView().environmentObject(DataModel())
    }
}
