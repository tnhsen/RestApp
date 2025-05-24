//
//  MainView.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var dataModel: DataModel

    var body: some View {
        TabView {
            wrappedNavigationView(view: HomePageView())
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            wrappedNavigationView(view: InfoView())
                .tabItem {
                    Label("Info", systemImage: "doc.text")
                }

            wrappedNavigationView(view: HistoryView())
                .tabItem {
                    Label("History", systemImage: "clock")
                }

            wrappedNavigationView(view: NotificationView())
                .tabItem {
                    Label("Notification", systemImage: "bell")
                }
        }
        .tint(Color(hex: colorLevel2))
//        .onAppear {
//            FetchData.fetchData(dataModel: dataModel)
//            dataModel.showAlert = false
//            
//            dataModel.NavigateToMain = false
//        }
    }
    
    @ViewBuilder
    private func wrappedNavigationView<V: View>(view: V) -> some View {
        NavigationView {
            view
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(destination: ProfileView()) {
                            if let image = dataModel.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }else {
                                Image(systemName: "person.circle")
                                    .font(.title)
                            }
//                            Image(systemName: "person.circle")
//                                .font(.title)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if(dataModel.userInfo.isDormitory){
                        ToolbarItem(placement: .navigationBarTrailing) {
                                            NavigationLink(destination: ChatListView()) {
                                                Image(systemName: "bubble.left.and.bubble.right.fill")
                                                    .font(.system(size: 20))
                                            }
                                            .buttonStyle(.plain)
                                        }
                    }
                }
               
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(DataModel())
    }
}
