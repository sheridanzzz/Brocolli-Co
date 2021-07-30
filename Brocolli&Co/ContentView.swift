//
//  ContentView.swift
//  Brocolli&Co
//
//  Created by user201819 on 7/26/21.
//

import SwiftUI
import ConfettiSwiftUI
import Combine
import SystemConfiguration


struct ContentView: View {
    @State private var isPresented = false
    
    //email check backend validation: usedemail@blinq.app
    //first view
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
                //to modally load next screen
                .fullScreenCover(isPresented: $isPresented, content: InviteView.init)
            }
            .navigationTitle("Brocolli & Co.")
        }
    }
}

//Invite view
struct InviteView: View {
    @EnvironmentObject var userAuth: DataPost
    @Environment(\.presentationMode) var presentationMode
    @State var isHideLoader: Bool = true
    @ObservedObject var inviteVm = InviteViewModel()
    @State var manager = DataPost()
    @ObservedObject var errMod = DataPost()
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var confirmEmail: String = ""
    @State var isclosed: Bool = true
    
    var body: some View{
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        //Brocolli and co image
                        Image("Brocolli_and_Co")
                            .resizable()
                            .scaledToFit()
                        //text fields for name and email
                        EntryField(sfSymbolName: "person", placeHolder: "Full Name", prompt: inviteVm.fullnamePrompt, field: $inviteVm.fullName)
                        EntryField(sfSymbolName: "envelope", placeHolder: "Email Address", prompt: inviteVm.emailPrompt, field: $inviteVm.email)
                        EntryField(sfSymbolName: "envelope", placeHolder: "Confirm Email Address", prompt: inviteVm.confirmEmPrompt, field: $inviteVm.confirmEm)
                        ZStack{
                            //loading screen in zStack
                            LoaderView(tintColor: .green, scaleSize: 1.0).padding(.bottom,50).hidden(isHideLoader)
                            HStack{
                                Button(action: {
                                    self.isHideLoader = !self.isHideLoader
                                    let secondsToDelay = 5.0
                                    //call function to call API
                                    self.errMod.checkDetails(name: inviteVm.fullName, email: inviteVm.email)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                                        //hide the loader
                                        self.isHideLoader.toggle()
                                    }
                                }) {
                                    Text("Send")
                                        .foregroundColor(.white)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
                                        .background(Capsule().fill(Color.green))
                                }
                                //alert box with showing alert is triggered
                                .alert(isPresented: $errMod.showingAlert, content: {
                                    Alert(title: Text("Error"), message: Text(errMod.errMess), dismissButton: .default(Text("OK")))
                                })
                                //button disabled until validation complete
                                .opacity(inviteVm.isInviteComplete ? 1 : 0.6)
                                .disabled(!inviteVm.isInviteComplete)
                                Button(action: {
                                    //dismiss view on cancel
                                    presentationMode.wrappedValue.dismiss()
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
                .navigationTitle("Invite Details")
                .padding()
                //move to next view on trigger
                .navigate(to: CongratulationsView(), when: $errMod.success)
            } // End of ZStack
            
            
        }
        
    }
}

//extension for moving between views
extension View {
    
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
    }
}

//Invite done view
struct CongratulationsView: View {
    @State var counter7:Int = 0
    @State private var isDismissed = false
    @State var isDone: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    //confetti
                    Text("🥦").font(.system(size: 50)).onTapGesture(){counter7 += 1}
                    //library for confetti functions
                    ConfettiCannon(counter: $counter7, num:1, confettis: [.text("🍆"), .text("🥕"), .text("🍠"), .text("🥬")], confettiSize: 30, repetitions: 50, repetitionInterval: 0.1)
                }
                Text("Congratulation! Invite Sent!")
            }
            //navbar item to close view
            .toolbar(content: {
                Button{
                    isDone.toggle()
                }label:{
                    Label("close", systemImage: "xmark")
                }
            })
        }.navigate(to: CancelInviteView(), when: $isDone)
    }
}

struct CancelInviteView: View {
    @State private var isPresented = false
    @State var isCancel: Bool = false
    
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
                    Text("Cancel Invite")
                        .bold()
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 50, alignment: .center)
                        .background(Capsule().fill(Color.green))
                })
                //alert box for delete invite
                .alert(isPresented: $isPresented) {
                    Alert(
                        title: Text("Are you sure you want to delete this?"),
                        message: Text("Can't Undo"),
                        primaryButton: .destructive(Text("Delete")) {
                            isCancel.toggle()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .navigationBarHidden(true)
            .navigate(to: CancelView(), when: $isCancel)
        }
    }
}

struct CancelView: View {
    @State var counter6:Int = 0
    @State private var isDismissed = false
    @State var isDone: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    Text("💩").font(.system(size: 50)).onTapGesture(){counter6 += 1}
                    ConfettiCannon(counter: $counter6, num:1, confettis: [.text("💩")], confettiSize: 20, repetitions: 100, repetitionInterval: 0.1)
                    
                }
                Text("Invite Cancelled!")
            }
            .toolbar(content: {
                Button{
                    isDone.toggle()
                }label:{
                    Label("close", systemImage: "xmark")
                }
            })
        }.navigate(to: ContentView(), when: $isDone)
    }
}

//hide view
extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

//loader and progress view
struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

//text fields for email and name
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

//code for API post request
class DataPost: ObservableObject {
    
    var didChange = PassthroughSubject<DataPost, Never>()
    
    @Published var errMess = ""
    @Published var value = 0
    
    @Published var showingAlert : Bool = false {
        didSet {
            didChange.send(self)
        }
    }
    
    @Published var success : Bool = false {
        didSet {
            didChange.send(self)
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
                    DispatchQueue.main.async {
                        self.showingAlert.toggle()
                        self.errMess = response1.errorMessage
                    }
                } else {
                    DispatchQueue.main.async {
                        self.success.toggle()
                    }
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
