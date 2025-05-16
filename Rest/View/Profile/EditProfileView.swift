//
//  EditProfileView.swift
//  Rest
//
//  Created by Me Tomm on 30/3/2568 BE.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Screen()
                    
                    Text("แก้ไขข้อมูลส่วนตัว")
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 15)
                        .font(.title)
                    
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
                        
                        Text("\(dataModel.userInfo.email)").opacity(0.5)
                            .padding()
                            .frame(width: 310, height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            

                        TextField("Phone", text: $dataModel.userInfo.phone)
                            .padding()
                            .frame(width: 310 ,height: 40)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .multilineTextAlignment(.center)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.6)
                    
                    HStack {
                        Button("Cancel") {
                            FetchData.fetchUserData(dataModel: dataModel)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                        .buttonStyle(.plain)
                        
                        Text("|").padding()
                        
                        Button("Save") {
                            dataModel.updateInfo()
                            
                        }
                        .padding()
                        .buttonStyle(.plain)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height - (geometry.size.height / 7))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $dataModel.showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Your information has been saved."),
                            dismissButton: .default(Text("OK")) {
                                dataModel.showAlert = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                    }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView().environmentObject(DataModel())
    }
}
