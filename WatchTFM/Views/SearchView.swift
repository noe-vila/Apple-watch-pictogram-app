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
            
            HStack {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: true) {
                        LazyHStack(spacing: 10) {
                            if viewModel.searchResults.isEmpty {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(Color.secondary, lineWidth: 4)
                                        .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.secondary.opacity(0.2)))
                                        .frame(width: 250, height: 250)
                                    Image(systemName: "figure.wave")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 100)
                                        .foregroundColor(Color.secondary)
                                }
                            } else {
                                ForEach(viewModel.searchResults, id: \.self) { pictogram in
                                    ZStack {
                                        //Reuse my previous roundedrectangle here instead of this one
                                        RoundedRectangle(cornerRadius: 20)
                                            .strokeBorder(Color.secondary, lineWidth: 4)
                                            .background(RoundedRectangle(cornerRadius: 20).foregroundColor(Color.secondary.opacity(0.2)))
                                            .frame(width: 250, height: 250)
                                        Image(uiImage: pictogram.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 250, height: 250)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .onTapGesture {
                                                onImageSelected(pictogram)
                                            }
                                    }
                                }
                            }
                        }
                        
                        .padding(.horizontal, !viewModel.searchResults.isEmpty ? max(0, (geometry.size.width - CGFloat(viewModel.searchResults.count * 250) - CGFloat((viewModel.searchResults.count - 1) * 10)) / 2) :  (geometry.size.width - CGFloat(250)) / 2)
                        
                    }
                }
            }
            .animation(.default, value: viewModel.searchResults.count < 2)
            
            VStack {
                HStack {
                    TextField("Buscar".uppercased(), text: $viewModel.searchText, onEditingChanged: { editing in
                        isEditing = editing
                    })
                    .foregroundColor(.white)
                    .onSubmit({
                        hideKeyboard()
                        viewModel.performSearch()
                    })
                    .keyboardType(.default)
                    .submitLabel(.search)
                    Button(action: {
                        hideKeyboard()
                        viewModel.performSearch()
                    }) {
                        if viewModel.isSearching {
                            ProgressView()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.primary)
                        } else {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.primary)
                        }
                    }
                }
                Divider()
                    .padding(.top, -1)
            }
            .padding()
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        if isEditing {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
