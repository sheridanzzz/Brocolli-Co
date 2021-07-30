//
//  InviteViewModel.swift
//  Brocolli&Co
//
//  Created by user201819 on 7/30/21.
//

import Foundation

class InviteViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var confirmEm = ""
    
    // MARK: - Validation Functions
    
    func emailsMatch() -> Bool {
        email == confirmEm
    }
    
    func isFullnameValid() -> Bool {
        fullName.count >= 3
    }
    
    func isEmailValid() -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: email)
    }
    
    
    var isInviteComplete: Bool {
        if !emailsMatch() ||
        !isEmailValid()
             {
            return false
        }
        return true
    }
    
    // MARK: - Validation Prompt Strings
    
    var confirmEmPrompt: String {
        if emailsMatch() {
            return ""
        } else {
            return "Email fields do not match"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() {
            return ""
        } else {
            return "Enter a valid email address"
        }
    }
    
    var fullnamePrompt: String {
        if isFullnameValid() {
            return ""
        } else {
            return "Must be at least 3 characters long"
        }
    }
}
