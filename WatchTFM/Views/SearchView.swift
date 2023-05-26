//
//  SearchView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var isEditing = false
    var onImageSelected: (PictogramResult) -> Void
    
    var body: some View {
        VStack {
            ZStack {
                if viewModel.searchResults.isEmpty {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
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
                VStack {
                    Spacer()
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
                    .padding()
                }
            }
        }
        .onTapGesture {
            if isEditing {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        .padding()
    }
}
