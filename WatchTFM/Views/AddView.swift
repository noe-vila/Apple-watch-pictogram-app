//
//  AddView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct AddView: View {
    @State private var taskName = ""
    @State private var selectedImage: Image? = Image(systemName: "photo")
    @State private var showingImageSearcher = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var isFormValid = false
    
    var body: some View {
        Form {
            Section(header: Text("Detalles de la tarea")) {
                TextField("Nombre de la tarea", text: $taskName)
            }
            
            Section(header: Text("Pictograma")) {
                Button(action: {
                    showingImageSearcher = true
                }) {
                    HStack {
                        Text("Buscar Pictograma")
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                        
                        Spacer()
                        
                        if let image = selectedImage {
                            image
                                .resizable()
                                .foregroundColor(.primary)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            
            Section(header: Text("Comienzo")) {
                DatePicker("Hora de comienzo", selection: $startTime, displayedComponents: [.hourAndMinute])
            }
            
            Section(header: Text("Fin")) {
                DatePicker("Hora de fin", selection: $endTime, displayedComponents: [.hourAndMinute])
            }
            
            Section {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        validateForm()
                    }) {
                        Text("Enviar")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
        .navigationBarTitle("Detalles de la tarea")
        .sheet(isPresented: $showingImageSearcher) {
            ImageSearcherView(selectedImage: $selectedImage)
        }
    }
    
    private func validateForm() {
        isFormValid = !taskName.isEmpty && selectedImage != nil && endTime > startTime
    }
}

struct ImageSearcherView: View {
    @Binding var selectedImage: Image?
    
    var body: some View {
        VStack {
            SearchView()
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
