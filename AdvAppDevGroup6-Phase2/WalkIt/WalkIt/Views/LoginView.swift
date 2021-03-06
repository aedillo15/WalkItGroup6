//
//  LoginView.swift
//  WalkIt
//
//  Created by user on 2021-11-08.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var coreDBHelper : CoreDBHelper

    @EnvironmentObject var loggedInPlayer : Player

    @State private var tfEmail: String = ""
    @State private var tfPassword : String = ""
    @State private var tfConfirmPassword : String = ""
    @State private var tfName : String = ""
    
    @State private var selection: Int? = nil
    @State private var invalidLogin: Bool = false
    @State private var alertMessage = ""
    
    var body: some View {
        
        VStack{
            NavigationLink(destination: ContentView(), tag: 1, selection: self.$selection){}
            
            Form{
                
                Text("Login")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding()
                    .frame(maxWidth: .infinity)
                
                TextField("Username", text: $tfName)
                                
                SecureField("Password", text: $tfPassword)
                
                Button(action: {
                    
                    if (self.validateEmptyData()){
                        print(#function, "Data is there")
                        
                        if (self.coreDBHelper.verifyUserExists(username: tfName, password: tfPassword)){
                            //self.loggedInPlayer = self.coreDBHelper.loginAs(username: tfName, password: tfPassword)!
                            self.selection = 1
                            print(#function, "User and password are correct")
                        } else {
                            print(#function, "Username \(tfName) or password \(tfPassword) is incorrect")
                            self.alertMessage = "Username or Password is incorrect"
                            self.invalidLogin = true
                        }

                    }else{
                        self.alertMessage = "Username or Password is missing"
                        self.invalidLogin = true
                    }
                }){
                    Text("Login")
                        .foregroundColor(.black)
                    
                }//Button
                .alert(isPresented: self.$invalidLogin){
                    Alert(
                        title: Text("Error"),
                        message: Text(self.alertMessage),
                        dismissButton: .default(Text("OK my bad"))
                    )
                }//alert
                
                Spacer()
            }//Form
        }//VStack
    }//body
    
    private func validateEmptyData() -> Bool{
        if (self.tfName.isEmpty){
            return false
        }
        if self.tfPassword.isEmpty{
            return false
        }

        
        return true
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
