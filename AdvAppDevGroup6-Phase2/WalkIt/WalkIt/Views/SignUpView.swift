//
//  SignUpView.swift
//  WalkIt
//
//  Created by user on 2021-11-08.
//

import SwiftUI

struct SignUpView: View {
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
                
                Text("Sign Up")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .padding()
                    .frame(maxWidth: .infinity)
                
                TextField("Username", text: $tfName)
                
                TextField("Email", text: $tfEmail)
                
                SecureField("Password", text: $tfPassword)
                
                Button(action: {
                    
                    if (self.validateEmptyData()){
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
        if (self.tfName.isEmpty){
            return false
        }
        if self.tfEmail.isEmpty{
            return false
        }
        if self.tfPassword.isEmpty{
            return false
        }

        
        return true
    }

}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
