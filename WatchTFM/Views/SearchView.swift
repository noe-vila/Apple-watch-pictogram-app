//
//  SearchView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct SearchView: View {
    @State var viewModel: SearchViewModel
    @State private var isEditing = false
    var onImageSelected: (PictogramResult) -> Void
    
    var body: some View {
        VStack {
            
            Spacer()
            ZStack {
                if viewModel.searchResults.isEmpty {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.gray, lineWidth: 4)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.gray.opacity(0.2)))
                        .frame(width: 250, height: 250)
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .foregroundColor(.gray)
                } else {
                    GeometryReader { geometry in
                        ScrollView(.horizontal, showsIndicators: true) {
                            LazyHStack(spacing: 10) {
                                ForEach(viewModel.searchResults, id: \.self) { pictogram in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 250, height: 250)
                                        Image(uiImage: pictogram.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 250, height: 250)
                                            .clipped()
                                            .onTapGesture {
                                                onImageSelected(pictogram)
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal, max(0, (geometry.size.width - CGFloat(viewModel.searchResults.count * 250) - CGFloat((viewModel.searchResults.count - 1) * 10)) / 2))
                        }
                    }
                }
            }
            
            Spacer()
            VStack {
                HStack {
                    TextField("Buscar", text: $viewModel.searchText, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .onSubmit({
                        viewModel.performSearch()
                    })
                    .keyboardType(.default)
                    .submitLabel(.done)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        hideKeyboard()
                        viewModel.performSearch()
                    }) {
                        if viewModel.isSearching {
                            ProgressView()
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .padding()
    }
    
    private func hideKeyboard() {
        if isEditing {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
