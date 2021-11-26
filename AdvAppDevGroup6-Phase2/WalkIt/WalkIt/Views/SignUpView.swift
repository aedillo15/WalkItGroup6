//
//  SignUpView.swift
//  WalkIt
//
//  Created by user on 2021-11-08.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var coreDBHelper : CoreDBHelper
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password : String = ""
    @State private var confirmPassword : String = ""
    @State private var name : String = ""
    
    @State private var selection: Int? = nil
    @State private var invalidLogin: Bool = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        VStack{
            NavigationLink(destination: ContentView(), tag: 1, selection: self.$selection){}
            
            Form{
                
                Text("Sign Up")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding()
                    .frame(maxWidth: .infinity)
                
                TextField("Username", text: $name)
                
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                
                Button(action: {
                    
                    if (self.validateEmptyData()){
                        self.addUser()
                        print(#function, "Account created successfully")
                            
                        self.selection = 1

                    }else{
                        self.alertMessage = "All the data is required."
                        self.invalidLogin = true
                    }
                }){
                    Text("Create Account")
                        .foregroundColor(.black)
                    
                }//Button
                .alert(isPresented: self.$invalidLogin){
                    Alert(
                        title: Text("Error"),
                        message: Text(self.alertMessage),
                        dismissButton: .default(Text("None of the fields can be blank"))
                    )
                }//alert
                
                Spacer()
            }//Form
        }//VStack
    }//body
    
    private func validateEmptyData() -> Bool{
        if (self.name.isEmpty){
            return false
        }
        if self.email.isEmpty{
            return false
        }
        if self.password.isEmpty{
            return false
        }

        
        return true
    }
    
    private func addUser(){
        print("Adding user to database")
        self.coreDBHelper.insertPlayer(newPlayer: Player(username: username, email: email, password: password))

    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
