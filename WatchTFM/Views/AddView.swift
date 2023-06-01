//
//  AddView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 24/5/23.
//

import SwiftUI
import CoreImage

struct AddView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var taskName = ""
    @State private var selectedImage: Image? = Image(systemName: "figure.wave")
    @State private var selectedImageURL: String = ""
    @State private var selectedImageData: Data = Data()
    @State private var showingImageSearcher = false
    @State private var zeroTime = Calendar.current.startOfDay(for: .now)
    @State private var startTime = Calendar.current.startOfDay(for: .now)
    @State private var endTime = Calendar.current.startOfDay(for: .now)
    @State private var isStartTimeModified = false
    @State private var isFormValid = false
    @State private var showOverlapAlert: Bool = false
    @State private var overlapedTask: String = ""
    @State private var avgColor: UIColor = UIColor.white
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
                    .background(isFormValid ? Color.primary : Color.gray)
                    .foregroundColor(
                        isFormValid ?
                            (colorScheme == .light ? .white : .black) :
                            (colorScheme == .light ? .black : .white)
                    )
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
            if !isStartTimeModified {
                isStartTimeModified = true
                endTime = startTime // Set endDate to be the same as startDate
            }
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
                avgColor = pictogramResult.image.dominantColor ?? UIColor.white
                showingImageSearcher = false
            }
        }
        
    }
    
    private func validateForm() {
        isFormValid = !taskName.isEmpty && selectedImage != nil && selectedImage != Image(systemName: "figure.wave") && endTime > startTime
    }
    
    private func performForm() {
        let calendar = Calendar.current

        var startComponents = calendar.dateComponents([.hour, .minute, .second], from: startTime)
        startComponents.year = 2000
        startComponents.month = 1
        startComponents.day = 1
        let startTimeWithHMS = calendar.date(from: startComponents)!

        var endComponents = calendar.dateComponents([.hour, .minute, .second], from: endTime)
        endComponents.year = 2000
        endComponents.month = 1
        endComponents.day = 1
        let endTimeWithHMS = calendar.date(from: endComponents)!

        let task = Task(imageData: selectedImageData,
                        name: taskName,
                        startDate: startTimeWithHMS,
                        endDate: endTimeWithHMS,
                        avgColorData: avgColor.encodeToData())

        if let overlapped = taskViewModel.addTask(task) {
            showOverlapAlert = true
            overlapedTask = overlapped
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

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: 1.0)
    }
    
    var dominantColor: UIColor? {
        guard let cgImage = self.cgImage else {
                return nil
            }
            
            let width = cgImage.width
            let height = cgImage.height
            
            // Create a bitmap context
            let bytesPerPixel = 4 // RGBA
            let bytesPerRow = bytesPerPixel * width
            let bitsPerComponent = 8
            let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
            let bitmapContext = CGContext(data: nil,
                                          width: width,
                                          height: height,
                                          bitsPerComponent: bitsPerComponent,
                                          bytesPerRow: bytesPerRow,
                                          space: CGColorSpaceCreateDeviceRGB(),
                                          bitmapInfo: bitmapInfo)!
            
            // Draw the image in the bitmap context
            let imageRect = CGRect(x: 0, y: 0, width: width, height: height)
            bitmapContext.draw(cgImage, in: imageRect)
            
            // Get pixel data from the bitmap context
            guard let pixelData = bitmapContext.data else {
                return nil
            }
            
            let data = pixelData.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
            
            var totalRed = 0
            var totalGreen = 0
            var totalBlue = 0
            var count = 0
            
            // Iterate through pixels and accumulate color components
            for pixel in 0..<(width * height) {
                let offset = pixel * bytesPerPixel
                let alpha = CGFloat(data[offset + 3]) / 255.0 // Alpha value
                
                // Skip transparent pixels
                if alpha > 0 {
                    totalRed += Int(data[offset])
                    totalGreen += Int(data[offset + 1])
                    totalBlue += Int(data[offset + 2])
                    count += 1
                }
            }
            
            // Calculate average color components
            let averageRed = CGFloat(totalRed) / CGFloat(count)
            let averageGreen = CGFloat(totalGreen) / CGFloat(count)
            let averageBlue = CGFloat(totalBlue) / CGFloat(count)
            
            return UIColor(red: averageRed / 255.0, green: averageGreen / 255.0, blue: averageBlue / 255.0, alpha: 1.0)
        }
    
}
