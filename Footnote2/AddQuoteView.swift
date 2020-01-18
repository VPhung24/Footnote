//
//  AddQuoteView.swift
//  Footnote2
//
//  Created by Cameron Bardell on 2019-12-10.
//  Copyright © 2019 Cameron Bardell. All rights reserved.
//

import SwiftUI

struct AddQuoteView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var text: String = ""
    @State var author: String = ""
    @State var title: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Button(action: {
                    self.addQuote()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color.white)
                     
                    
                }
                TextField("Text", text: self.$text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Title", text: self.$title)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing, .bottom])
                    .disableAutocorrection(true)
                
                TextField("Author", text: self.$author)
                    .textContentType(.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
                    .disableAutocorrection(true)
                
                AuthorSuggestionsView(filter: self.author, text: self.$author).environment(\.managedObjectContext, self.managedObjectContext)
                    .frame(width: geometry.size.width - 30, height: 50)
                
                TitleSuggestionsView(filter: self.title, text: self.$title).environment(\.managedObjectContext, self.managedObjectContext)
                .frame(width: geometry.size.width - 30, height: 50)
                
                Text("Add Quote").font(.title).foregroundColor(Color.white)
                Text("Swipe to dismiss").font(.footnote).foregroundColor(Color.white)
                Spacer()
                
            }.frame(width: geometry.size.width - 20, height: geometry.size.height)
                .background(Color.footnoteRed)
                .cornerRadius(10)
        }
    }
    
    func addQuote() {
        // Add a new quote
        let quote = Quote(context: self.managedObjectContext)
        quote.title = self.title
        quote.text = self.text
        quote.author = self.author
        quote.dateCreated = Date()
        
        let authorItem = Author(context: self.managedObjectContext)
        authorItem.text = self.author
        authorItem.count += 1
        
        let titleItem = Title(context: self.managedObjectContext)
        titleItem.text = self.title
        titleItem.count += 1
        
        do {
            try self.managedObjectContext.save()
        } catch {
            // handle the Core Data error
        }
        
        title = ""
        text = ""
        author = ""
    }
}

struct AuthorSuggestionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest: FetchRequest<Author>
    
    @Binding var text: String
    
    init(filter: String, text: Binding<String>) {
        fetchRequest = FetchRequest<Author>(entity: Author.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Author.count, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                ]
        ))
        
        // Initialize a binding variable
        self._text = text
        
    }
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                // Couldn't figure out fetchlimit with SwiftUI, leading to this monstrosity.
                if self.fetchRequest.wrappedValue.count >= 2 {
                    Group {
                        Button(action: {
                            
                            self.text = self.fetchRequest.wrappedValue[0].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[0].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                } else {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { item in
                        Button(action: {
                            
                                self.text = item.text ?? ""
            
                        }) {
                            Text(item.text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct TitleSuggestionsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var fetchRequest: FetchRequest<Title>
    
    @Binding var text: String
    
    init(filter: String, text: Binding<String>) {
        fetchRequest = FetchRequest<Title>(entity: Title.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Title.count, ascending: false)
            ], predicate: NSCompoundPredicate(
                type: .or,
                subpredicates: [
                    // [cd] = case and diacritic insensitive
                    NSPredicate(format: "text CONTAINS[cd] %@", filter),
                ]
        ))
        print("init")
        // Initialize a binding variable
        self._text = text
        
    }
    var body: some View {
        GeometryReader { geometry in
            
            HStack {
                // Couldn't figure out fetchlimit with SwiftUI, leading to this monstrosity.
                if self.fetchRequest.wrappedValue.count >= 2 {
                    Group {
                        Button(action: {
                            
                            self.text = self.fetchRequest.wrappedValue[0].text ?? ""
                            
                        }) {
                            Text(self.fetchRequest.wrappedValue[0].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                        
                       Button(action: {
                            
                                self.text = self.fetchRequest.wrappedValue[1].text ?? ""

                        }) {
                            Text(self.fetchRequest.wrappedValue[1].text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                } else {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { item in
                        Button(action: {
                            
                                self.text = item.text ?? ""
            
                        }) {
                            Text(item.text ?? "")
                                .foregroundColor(Color.footnoteOrange)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(10)
                            .frame(width: geometry.size.width / 2 - 5, height: 50)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}


struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView()
    }
}