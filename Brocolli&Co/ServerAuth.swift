////
////  ServerAuth.swift
////  Brocolli&Co
////
////  Created by user201819 on 7/31/21.
////
//
//import Foundation
//import Combine
//import SwiftUI
//import SystemConfiguration
//
//class AuthUser: ObservableObject {
//
//    // membuat didchange
//    var didChange = PassthroughSubject<AuthUser, Never>()
//
//    @Published var isCorrect : Bool = true
//    @Published var email : String = ""
//    @Published var name : String = ""
//    @Published var errorMessage : String = ""
//    @Published var isConnected : Bool = true
//    @Published var isAlert : Bool = true
//    // buat var state
//    @Published var isApiReachable : Bool = true {
//        didSet {
//            didChange.send(self)
//        }
//    }
//
//    // rubah state
//    @Published var isLoggedin : Bool = false {
//        didSet {
//            didChange.send(self)
//        }
//    }
//
//    // fungsi cek login
//    func cekLogin(name: String, email: String){
//
//        //3 pasang url
//        guard let url = URL(string: "https://us-central1-blinkapp-684c1.cloudfunctions.net/fakeAuth") else {
//            return
//        }
//
//        let body : [String : String] = ["name": name, "email": email]
//
//        guard let finalBody = try? JSONEncoder().encode(body) else {
//            return
//        }
//
//        var request = URLRequest(url: url)
//
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = finalBody
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//            //4 set isApiReachable
//            guard let data = data, error == nil else {
//                print("No data response")
//
//                DispatchQueue.main.async {
//                    self.isApiReachable = false
//                }
//                return
//
//            }
//
//            // decode data
//            let result = try? JSONDecoder().decode(Response.self, from: data)
//
//            if let result = response {
//                DispatchQueue.main.async {
////                    if(result.success){
////                        self.isLoggedin = true
////                        //ubah status isCorrect
////                        self.isCorrect = true
////                        self.isAlert = false
////                    }else {
////                        self.isCorrect = false
////                        self.isAlert = true
////                    }
//                    if response.statusCode == 400 {
//                        let response1: Response = try! JSONDecoder().decode(Response.self, from: jsonData ?? data)
//                        DispatchQueue.main.async {
//                            self.showingAlert.toggle()
//                            self.success.toggle()
//                        }
//                        self.showingAlert.toggle()
//                        self.errMess = response1.errorMessage
//                        print(self.errMess)
//                        print(self.showingAlert)
//                    }
//                }
//
//            } else {
//                DispatchQueue.main.async {
//                    self.isCorrect = false
//                    print("Invalid response from web services!")
//                }
//            }
//
//        }.resume()
//    }
//
//    struct Response: Decodable {
//        let errorMessage: String
//    }
//
//}
