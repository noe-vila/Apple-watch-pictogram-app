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
    @State private var selectedImageURL: String = ""
    @State private var selectedImageData: Data = Data()
    @State private var showingImageSearcher = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var isFormValid = false
    var taskViewModel: TaskViewModel
    @Binding var isPresentingAddView: Bool
    @Binding var refreshHome: Bool

    
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
                        performForm()
                    }) {
                        Text("Guardar")
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
        .onChange(of: taskName, perform: { _ in
            validateForm()
        })
        .onChange(of: selectedImage, perform: { _ in
            validateForm()
        })
        .onChange(of: startTime, perform: { _ in
            validateForm()
        })
        .onChange(of: endTime, perform: { _ in
            validateForm()
        })
        .navigationBarTitle("Detalles de la tarea")
        .sheet(isPresented: $showingImageSearcher) {
            ImageSearcherView(selectedImage: $selectedImage) { pictogramResult in
                selectedImage = Image(uiImage: pictogramResult.image)
                selectedImageURL = pictogramResult.imageURL
                selectedImageData = pictogramResult.image.pngData() ?? Data()
                showingImageSearcher = false
            }
        }
    }
    
    private func validateForm() {
        isFormValid = !taskName.isEmpty && selectedImage != nil && selectedImage != Image(systemName: "photo") && endTime > startTime
    }
    
    private func performForm() {
        let task = Task(imageData: selectedImageData, name: taskName, startDate: startTime, endDate: endTime)
        taskViewModel.addTask(task)
        refreshHome.toggle()
        isPresentingAddView = false
    }
}

struct ImageSearcherView: View {
    @Binding var selectedImage: Image?
    var onImageSelected: (PictogramResult) -> Void
    
    var body: some View {
        VStack {
            SearchView(onImageSelected: onImageSelected)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
