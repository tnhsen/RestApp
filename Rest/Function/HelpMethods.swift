//
//  HelpMethods.swift
//  Rest
//
//  Created by Me Tomm on 7/5/2568 BE.
//

import Firebase
import FirebaseAuth

public class HelpMethods {
    
    static let successStatus = "Success"
    static let failedStatus = "Failed"
    
    static func showAlert(status: String, dataModel: DataModel){
        dataModel.alertStatus = status
        switch status {
            case "Success":
                dataModel.alertDetail = "Your information has been saved."
                break;
            case "Failed":
                dataModel.alertDetail = "Something went wrong."
                break;
        default:
            break;
        }
        dataModel.showAlert = true
    }
    
    static func sendResetPasswordEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("error: \(error)")
            } else {
               
            }
        }
    }

    
}
