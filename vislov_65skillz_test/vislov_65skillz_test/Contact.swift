//
//  Contacts_data.swift
//  vislov_65skillz_test
//
//  Created by Ivan Vislov on 26.09.2021.
//

import SwiftUI
import Foundation

struct Contact: Hashable, Codable, Identifiable {
    var id = UUID()
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var email: String
    var dateOfBirth: String
    var company: String
    var isFavorite: Bool
}

let contactData = [
    Contact(firstName: "Tim", lastName: "Cook", phoneNumber: "+ 7 (911) 111-1111", email: "tcook@apple.com", dateOfBirth: "01.10.1960", company: "Apple", isFavorite: true),
    Contact(firstName: "Jony", lastName: "Ive", phoneNumber: "+ 7 (922) 222-2222", email: "jive@lovefrom.com", dateOfBirth: "27.02.1967", company: "LoveFrom", isFavorite: false),
    Contact(firstName: "Sundar", lastName: "Pichai", phoneNumber: "+ 7 (933) 333-3333", email: "sundar@google.com", dateOfBirth: "12.07.1972", company: "Google", isFavorite: false),
    Contact(firstName: "Pavel", lastName: "Durov", phoneNumber: "+ 7 (944) 444-4444", email: "durov@telegram.com", dateOfBirth: "10.10.1984", company: "Telegram", isFavorite: true)
]
