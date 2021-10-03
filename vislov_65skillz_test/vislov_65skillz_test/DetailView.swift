//
//  DetailView.swift
//  vislov_65skillz_test
//
//  Created by Ivan Vislov on 26.09.2021.
//

import SwiftUI

struct DetailView: View {
    
    var contact: Contact
    @EnvironmentObject var userData: UserData
    var contactIndex: Int {
        userData.contacts.firstIndex(where: {$0.id == contact.id })!
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(contact.firstName)
                    .font(.title)
                    .fontWeight(.medium)
                Text(contact.lastName)
                    .font(.title)
                    .fontWeight(.medium)
                Button(action: {
                    self.userData.contacts[self.contactIndex].isFavorite.toggle()
                }) {
                    if self.userData.contacts[self.contactIndex].isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    } else {
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Form {
                HStack {
                    Text("Date of Birth")
                    Spacer()
                    Text(contact.dateOfBirth)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Phone")
                    Spacer()
                    Text(contact.phoneNumber)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text(contact.email)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Company")
                    Spacer()
                    Text(contact.company)
                        .foregroundColor(.gray)
                        .font(.callout)
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(contact: contactData[0])
            .environmentObject(UserData())
    }
}
