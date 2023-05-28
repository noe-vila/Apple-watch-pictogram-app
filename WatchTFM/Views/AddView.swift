//
//  AddView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct AddView: View {
    @State private var taskName = ""
    @State private var selectedImage: Image? = Image(systemName: "figure.wave")
    @State private var selectedImageURL: String = ""
    @State private var selectedImageData: Data = Data()
    @State private var showingImageSearcher = false
    @State private var zeroTime = Calendar.current.startOfDay(for: .now)
    @State private var startTime = Calendar.current.startOfDay(for: .now)
    @State private var endTime = Calendar.current.startOfDay(for: .now)
    @State private var isFormValid = false
    @State private var showOverlapAlert: Bool = false
    @State private var overlapedTask: String = ""
    var taskViewModel: TaskViewModel
    @StateObject var searchViewModel = SearchViewModel()
    @Binding var isPresentingAddView: Bool
    @Binding var refreshHome: Bool
    
    
    var body: some View {
        VStack (spacing: 50) {
            Spacer()
            VStack (spacing: 5) {
                TextField("", text: $taskName)
                    .placeholder(when: taskName.isEmpty) {
                        Text("Nombre de la tarea".uppercased())
                    }
                    .keyboardType(.default)
                    .submitLabel(.done)
                    .onSubmit {
                        searchViewModel.searchText = taskName
                        searchViewModel.performSearch()
                    }
                Divider()
            }
            .foregroundColor(taskName.isEmpty ? .secondary : .primary)
            
            VStack (spacing: 5) {
                Button(action: {
                    if !taskName.isEmpty {
                        searchViewModel.searchText = taskName
                        searchViewModel.performSearch()
                    }
                    showingImageSearcher = true
                    self.endTextEditing()
                }) {
                    HStack {
                        Text(selectedImage != nil && selectedImage != Image(systemName: "figure.wave") ? "Pictograma".uppercased() : "Buscar Pictograma".uppercased())
                            .cornerRadius(10)
                            .padding(.bottom, -25)
                        
                        Spacer()
                        
                        if let image = selectedImage {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                        }
                    }
                }
                Divider()
            }
            .foregroundColor(selectedImage != nil && selectedImage != Image(systemName: "figure.wave") ? .primary : .secondary)
            
            
            VStack (spacing: 5) {
                DatePicker("Hora de comienzo".uppercased(), selection: $startTime, displayedComponents: [.hourAndMinute])
                Divider()
            }
            .foregroundColor(startTime > zeroTime || endTime > startTime ? .primary : .secondary)
            
            VStack (spacing: 5) {
                DatePicker("Hora de fin".uppercased(), selection: $endTime, displayedComponents: [.hourAndMinute])
                Divider()
            }
            .foregroundColor(endTime > startTime ? .primary : .secondary)
            
            Spacer()
            
            Button(action: {
                performForm()
            }) {
                Text("Guardar".uppercased())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.headline)
                    .foregroundColor(isFormValid ? .black : .white)
                    .background(isFormValid ? Color.primary : Color.gray)
                    .cornerRadius(5)
            }
            .disabled(!isFormValid)
            .alert(isPresented: $showOverlapAlert) {
                Alert(title: Text("Error añadiendo tarea"),
                      message: Text("La tarea que intentas añadir se superpone en el tiempo con \(overlapedTask), por favor, modifica el tiempo para que no se superpongan y vuelve a guardar"),
                      dismissButton: .default(Text("OK"))
                )
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
        .padding()
        .sheet(isPresented: $showingImageSearcher) {
            ImageSearcherView(selectedImage: $selectedImage, searchViewModel: searchViewModel) { pictogramResult in
                selectedImage = Image(uiImage: pictogramResult.image)
                selectedImageURL = pictogramResult.imageURL
                selectedImageData = pictogramResult.image.pngData() ?? Data()
                showingImageSearcher = false
            }
        }
        
    }
    
    private func validateForm() {
        isFormValid = !taskName.isEmpty && selectedImage != nil && selectedImage != Image(systemName: "figure.wave") && endTime > startTime
    }
    
    private func performForm() {
        let task = Task(imageData: selectedImageData, name: taskName, startDate: startTime, endDate: endTime)
        if let overlaped = taskViewModel.addTask(task) {
            showOverlapAlert = true
            overlapedTask = overlaped
        } else {
            refreshHome.toggle()
            isPresentingAddView = false
        }
    }
}

struct ImageSearcherView: View {
    @Binding var selectedImage: Image?
    @StateObject var searchViewModel: SearchViewModel
    var onImageSelected: (PictogramResult) -> Void
    
    var body: some View {
        VStack {
            SearchView(viewModel: searchViewModel, onImageSelected: onImageSelected)
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
