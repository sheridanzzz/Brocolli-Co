//
//  ContentView.swift
//  Brocolli&Co
//
//  Created by user201819 on 7/26/21.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            VStack() {
                Image("Brocolli_and_Co")
                    .resizable()
                    .scaledToFit()
                Text("Welcome to Brocolli & Co.").padding()
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Text("Request Invite")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Capsule().fill(Color.green))
                })
                .fullScreenCover(isPresented: $isPresented, content: {
                    InviteView(isPresented: $isPresented)
                })
            }
            .navigationTitle("Brocolli & Co.")
        }
    }
}

struct InviteView: View {
    @State var isHideLoader: Bool = true
    @ObservedObject var inviteVm = InviteViewModel()
    @State var manager = DataPost()
//    @State var showingAlert = false
//    @State var errMess = ""
    @ObservedObject var errMod = DataPost()
    
    
    
    @Binding var isPresented: Bool
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var confirmEmail: String = ""
    
    var body: some View{
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        Image("Brocolli_and_Co")
                            .resizable()
                            .scaledToFit()
                        EntryField(sfSymbolName: "person", placeHolder: "Full Name", prompt: inviteVm.fullnamePrompt, field: $inviteVm.fullName)
                        EntryField(sfSymbolName: "envelope", placeHolder: "Email Address", prompt: inviteVm.emailPrompt, field: $inviteVm.email)
                        EntryField(sfSymbolName: "envelope", placeHolder: "Confirm Email Address", prompt: inviteVm.confirmEmPrompt, field: $inviteVm.confirmEm)
                        ZStack{
                            LoaderView(tintColor: .green, scaleSize: 1.0).padding(.bottom,50).hidden(isHideLoader)
                            HStack{
                                Button(action: {
                                    //self.showingAlert.toggle()
                                    print("1st")
                                    print(errMod.showingAlert)
                                    print(errMod.errMess)
                                    self.isHideLoader = !self.isHideLoader
                                    let secondsToDelay = 5.0
                                    self.manager.checkDetails(name: inviteVm.fullName, email: inviteVm.email)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {

                                        self.isHideLoader.toggle()
                                    }
                                }) {
                                    Text("Send")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                        .background(Capsule().fill(Color.green))
                                }
                                .fullScreenCover(isPresented: $errMod.success, content: {
                                    CongratulationsView()
                                })
                                .alert(isPresented: $errMod.showingAlert, content: {
                                    Alert(title: Text("Error"), message: Text(errMod.errMess), dismissButton: .default(Text("OK")))
                                
    
                                    
                                })
                                .opacity(inviteVm.isInviteComplete ? 1 : 0.6)
                                .disabled(!inviteVm.isInviteComplete)
                                
                                Button(action: {
                                    self.isPresented.toggle()
                                }) {
                                    Text("cancel")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                        .background(Capsule().fill(Color.green))
                                }
                            }
                        }
                        
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    
                    Spacer()
                }
                .padding()
            } // End of ZStack
            
            .navigationTitle("Invite Details")
            
        }
        
    }
}

struct CongratulationsView: View {
    @State var counter7:Int = 0

     var body: some View {
        VStack{
         ZStack{
             Text("🥦").font(.system(size: 50)).onTapGesture(){counter7 += 1}
            ConfettiCannon(counter: $counter7, num:1, confettis: [.text("🍆"), .text("🥕"), .text("🍠"), .text("🥬")], confettiSize: 30, repetitions: 50, repetitionInterval: 0.1)
            
         }
            Text("Congratulations! Invite Sent!")
        }
     }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}


struct EntryField: View {
    var sfSymbolName: String
    var placeHolder: String
    var prompt: String
    @Binding var field: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                TextField(placeHolder, text: $field).autocapitalization(.none)
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            Text(prompt)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}


class DataPost: ObservableObject {
    @Published var errMess = "its me"
    @Published var showingAlert = false
    @Published var success = false
    @Published var value = 0

    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
                if (self.value == 10)
                {
                    self.success.toggle()
                }
                
            }
        }
    }
    func checkDetails(name: String,  email: String) {
        
        let body: [String: Any] = ["name": name, "email": email]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        let url = URL(string: "https://us-central1-blinkapp-684c1.cloudfunctions.net/fakeAuth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            print("-----> data: \(String(describing: data))")
            print("-----> error: \(String(describing: error))")
            print("status")
            
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                print("statusCode: \(response.statusCode)")
                print(String(data: data, encoding: .utf8) ?? "")
                
                let ses = String(data: data, encoding: .utf8) ?? ""
                let jsonData = ses.data(using: .utf8)
                if response.statusCode == 400 {
                    let response1: Response = try! JSONDecoder().decode(Response.self, from: jsonData ?? data)
                    
                        self.showingAlert.toggle()
                        self.errMess = response1.errorMessage
                        print(self.errMess)
                        print(self.showingAlert)
                }
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print("-----1> responseJSON: \(String(describing: responseJSON))")
            
            if let responseJSON = responseJSON as? [String: Any] {
                print("-----2> responseJSON: \(responseJSON)")
            }
        }
        task.resume()
    }
    
}

struct Response: Decodable {
    let errorMessage: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
