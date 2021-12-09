//
//  SettingsScreen.swift
//  WalkIt
//
//  Created by user on 2021-10-29.
//

import SwiftUI

struct SettingsScreen: View {
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
                
                Text("Account Information")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding()
                    .frame(maxWidth: .infinity)
                
                Text("Username: \(self.username)")
                
                Text("Email: \(self.email)")
                
                Text("Password: *******" )
                
                
                Text("Update information")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding()
                    .frame(maxWidth: .infinity)
                
                TextField("New Username", text: $name)
                
                TextField("Email Change", text: $email)
                
                SecureField("New Password", text: $password)
                
//                SecureField("Confirm Password", text: confirmPassword)
                
                Button(action: {
                    
                    if (self.validateEmptyData()){
                        self.updateUser()
                        print(#function, "Account updated successfully")
                            
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
                        dismissButton: .default(Text("None of the fields can be blank, if you are not updating please put your old information"))
                    )
                }//alert
                Spacer()
            }//Form
        }//VStack
    }//body

    
    private func validateEmptyData() -> Bool{
        if (self.username.isEmpty){
            return false
        }
        if self.email.isEmpty{
            return false
        }
        if self.password.isEmpty{
            return false
        }
//        if (self.password !== self.confirmPassword){
//            return false
//        }

        
        return true
    }
    
    private func updateUser(){
        print("Update user to database")
        self.coreDBHelper.insertPlayer(newPlayer: Player(username: username, email: email, password: password))

    }

}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
