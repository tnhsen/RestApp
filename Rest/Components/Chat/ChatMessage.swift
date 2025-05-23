//
//  ChatMessage.swift
//  Rest
//
//  Created by Me Tomm on 15/5/2568 BE.
//

import SwiftUI

struct ChatMessageView: View {
    var chat: ChatMetaModel
    @EnvironmentObject var dataModel: DataModel
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    
                    LazyVStack(alignment: .leading, spacing: 10) {
                        
                        //let messages = dataModel.chatMessage[chat.chatId] ?? []

                        let messages = dataModel.chatMessage[chat.chatId] ?? []
                        let groupedMessages = Dictionary(grouping: messages) { message in
                            Calendar.current.startOfDay(for: message.timestamp)
                        }
                        let sortedDates = groupedMessages.keys.sorted()

                        
//                        ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
//                            VStack(alignment: message.senderId == dataModel.userInfo.id ? .trailing : .leading, spacing: 2) {
//                                if message.senderId != dataModel.userInfo.id &&
//                                    (index == 0 || messages[index - 1].senderId == dataModel.userInfo.id) {
//                                    Text(getOtherUserMember(chat: chat, dataModel: dataModel))
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//
//                                HStack {
//                                    if message.senderId == dataModel.userInfo.id {
//                                        Spacer()
//                                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
//                                            .font(.caption2)
//                                            .foregroundColor(.gray)
//                                        Text(message.text)
//                                            .padding()
//                                            .background(Color(hex: colorLevel1))
//                                            .foregroundColor(.white)
//                                            .cornerRadius(12)
//                                    } else {
//                                        Text(message.text)
//                                            .padding()
//                                            .background(Color.gray.opacity(0.2))
//                                            .cornerRadius(12)
//                                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))
//                                            .font(.caption2)
//                                            .foregroundColor(.gray)
//                                        Spacer()
//                                    }
//                                }
//                                .id(message.id)
//                            }
//                        }
                        
                        ForEach(sortedDates, id: \.self) { date in
                            Section {
                                if let messagesForDate = groupedMessages[date] {
                                    ForEach(Array(messagesForDate.enumerated()), id: \.element.id) { index, message in
                                        VStack(alignment: message.senderId == dataModel.userInfo.id ? .trailing : .leading, spacing: 2) {
                                            if message.senderId != dataModel.userInfo.id &&
                                                (index == 0 || messagesForDate[index - 1].senderId == dataModel.userInfo.id) {
                                                Text(getOtherUserMember(chat: chat, dataModel: dataModel))
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }

                                            HStack {
                                                if message.senderId == dataModel.userInfo.id {
                                                    Spacer()
                                                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                    Text(message.text)
                                                        .padding()
                                                        .background(Color(hex: colorLevel1))
                                                        .foregroundColor(.white)
                                                        .cornerRadius(12)
                                                } else {
                                                    Text(message.text)
                                                        .padding()
                                                        .background(Color.gray.opacity(0.2))
                                                        .cornerRadius(12)
                                                    Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                    Spacer()
                                                }
                                            }
                                            .id(message.id)
                                        }
                                    }
                                }
                            }
//                            header: {
//                                Text(date.formatted(date: .abbreviated, time: .omitted))
//                                    .font(.caption)
//                                    .foregroundColor(.secondary)
//                                    .padding(.top, 10)
//                            }
                            
                            header: {
                                HStack {
                                    Spacer()
                                    Text(thaiDateString(from: date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.vertical, 5)
                                    Spacer()
                                }
                            }

                        }

                    }



//                    LazyVStack(alignment: .leading, spacing: 10) {
//                        ForEach(dataModel.chatMessage[chat.chatId] ?? [], id: \.id) { message in
//                            HStack {
//                                if message.senderId == dataModel.userInfo.id {
//                                    Spacer()
//                                    Text(message.text)
//                                        .padding()
//                                        .background(Color(hex: colorLevel1))
//                                        .foregroundColor(.white)
//                                        .cornerRadius(12)
//                                } else {
//                                    Text(message.text)
//                                        .padding()
//                                        .background(Color.gray.opacity(0.2))
//                                        .cornerRadius(12)
//                                    Spacer()
//                                }
//                            }
//                            .id(message.id)
//                        }
//                    }
                }
                .onChange(of: dataModel.chatMessage[chat.chatId]?.count) { _ in
                    if let last = dataModel.chatMessage[chat.chatId]?.last {
                        withAnimation {
                            scrollView.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }

            HStack {
                TextField("พิมพ์ข้อความ...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    guard !newMessage.isEmpty else { return }
                    ChatMethods.addChat(
                        senderUID: dataModel.userInfo.id,
                        senderName: dataModel.userInfo.firstName,
                        receiverUID: getOtherUserId(from: chat.chatId, currentUserId: dataModel.userInfo.id), username: getOtherUserMember(chat: chat, dataModel: dataModel),
                        message: newMessage
                    )
                    newMessage = ""
                    FetchData.fetchMessages(chatId: chat.chatId, dataModel: dataModel)
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2).foregroundColor(Color(hex: colorLevel1))
                }
            }
            .padding()
        }
        .padding(10)
        .navigationTitle(getOtherUserMember(chat: chat, dataModel: dataModel))
        .onAppear {
            FetchData.fetchMessages(chatId: chat.chatId, dataModel: dataModel)
        }
    }
    
    
    func thaiDateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th_TH")
        formatter.calendar = Calendar(identifier: .buddhist)
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

}
