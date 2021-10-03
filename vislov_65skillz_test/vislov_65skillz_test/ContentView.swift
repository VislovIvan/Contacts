//
//  ContentView.swift
//  vislov_65skillz_test
//
//  Created by Ivan Vislov on 26.09.2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresentingAddModal = false
    @State var searchText = ""
    @EnvironmentObject var userData: UserData
    @State var showFavoritesOnly = false
    @State var isSearching = false
    var contact: Contact
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        TextField("Search", text: $searchText)
                            .padding(.leading, 25)
                    }
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onTapGesture(perform: {
                        isSearching = true
                    })
                    .overlay(
                        HStack {
                        Image(systemName: "magnifyingglass")
                        Spacer()
                        
                        if isSearching {
                            Button(action: { searchText = "" }, label: {
                                Image(systemName: "xmark.circle.fill")
                            })
                        }
                    }.padding(.horizontal, 25)
                        .foregroundColor(.gray)
                    )
                    .transition(.move(edge: .trailing))
                        .animation(.spring())
                    
                    if isSearching {
                    Button(action: {
                        isSearching = false
                        searchText = ""
                        
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    }, label: {
                      Text("Cancel")
                            .padding(.trailing)
                            .padding(.leading, 0)
                    })
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                    }
                }
                
                List {
                    Toggle(isOn: $showFavoritesOnly) {
                        Text("Favorites Only")
                    }
                    ForEach(userData.contacts.filter({ "\($0)".contains(searchText) || searchText.isEmpty })) { contact in
                        
                        if !self.showFavoritesOnly || contact.isFavorite {
                            NavigationLink(destination: DetailView(contact: contact)) {
                                ContactRow(contact: contact)
                            }
                        }
                    }
                    .onDelete { self.userData.contacts.remove(atOffsets: $0) }
                }
                .navigationBarTitle("Contacts")
                .navigationBarItems(trailing: Button(action: {
                    print("Trying to add new person")
                    self.isPresentingAddModal.toggle()
                    
                }, label: {
                    Image(systemName: "plus.app")
                }))
                .sheet(isPresented: $isPresentingAddModal, content: {
                    AddModal(isPresented: $isPresentingAddModal, didAddPerson: {
                        contact in
                        
                        self.userData.contacts.append(contact)
                        
                    })
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(contact: contactData[0])
            .environmentObject(UserData())
    }
}

//Add new contact

struct AddModal: View {
    
    @Binding var isPresented: Bool
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var dateOfBirth = ""
    @State private var company = ""
    @ObservedObject var emailObj = EmailValidationObj()
    var didAddPerson: (Contact) -> ()
    
    var body: some View {
        VStack {
            Form {
                HStack(spacing: 15) {
                    Text("First Name")
                    TextField("Enter First Name", text: $firstName)
                        .onChange(of: firstName, perform: { oldValue in
                            firstName = nameFormat(with: "XXXXXXXXXXXXXXXXXXXXX", name: oldValue)
                        })
                }
                
                HStack(spacing: 15)  {
                    Text("Last Name")
                    TextField("Enter Last Name", text: $lastName)
                        .onChange(of: lastName, perform: { oldValue in
                            lastName = nameFormat(with: "XXXXXXXXXXXXXXXXXXXXX", name: oldValue)
                        })
                }
                
                HStack(spacing: 15)  {
                    Text("Phone Number")
                    TextField("Enter Phone Number", text: $phoneNumber)
                        .onChange(of: phoneNumber, perform: { oldValue in
                            phoneNumber = format(with: "+X (XXX) XXX-XX XX", phone: oldValue)
                        })
                }
                
                HStack(spacing: 15)  {
                    Text("Email")
                    TextField("Enter Email", text: $emailObj.email)
                    Text(emailObj.error).foregroundColor(.red)
                }
                
                HStack(spacing: 15)  {
                    Text("Date of Birth")
                    TextField("Enter Date of Birth", text: $dateOfBirth)
                        .onChange(of: dateOfBirth, perform: { oldValue in
                            dateOfBirth = format(with: "XX.XX.XXXX", phone: oldValue)
                        })
                }
                
                HStack(spacing: 15)  {
                    Text("Company")
                    TextField("Enter Company", text: $company)
                }
                
                Button(action: {
                    self.isPresented = false
                    
                    self.didAddPerson(.init(firstName: self.firstName, lastName: self.lastName, phoneNumber: self.phoneNumber, email: self.emailObj.email, dateOfBirth: self.dateOfBirth, company: self.company, isFavorite: false))
                    
                    
                }, label: {
                    Text("Add")
                })
                
                Button(action: {
                    self.isPresented = false
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                })
                
            }.padding(.all, 15)
        }
    }
    
    //Validation for Phone
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    //Validation for Name
    
    func nameFormat(with mask: String, name: String) -> String {
        let numbers = name.replacingOccurrences(of: "[^a-zA-ZА-Яа-я]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

//Email validation

class EmailValidationObj: ObservableObject {
    @Published var email = "" {
        didSet {
            if self.email.isEmpty {
                self.error = ""
            } else if !self.email.isValidEmail() {
                self.error = "Invalid Email"
            } else {
                self.error = ""
            }
        }
    }
    @Published var error = ""
}

extension String {
func isValidEmail() -> Bool {
    let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    
    let emailValidation = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
    return emailValidation.evaluate(with: self)
    }
}

struct ContactRow: View {
    
    let contact: Contact
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(contact.firstName)
                        .font(.system(size: 21, weight: .medium, design: .default))
                    Text(contact.lastName)
                        .font(.system(size: 21, weight: .medium, design: .default))
                    
                }
                Text(contact.phoneNumber)
                Text(contact.company)
            }
            if contact.isFavorite == true {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            } else {
                Image(systemName: "star")
            }
        }
    }
}
