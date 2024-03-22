//
//  ImageToImageView.swift
//  StableDiffusionApp
//
//  Created by MaxMobile Software on 18/03/2024.
//

import SwiftUI
import AlertToast

struct ImageToImageView: View {
    @State private var image: Image?
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State var loading: Bool = false
    @State var imageBase64: String = ""
    @State var alertSaveSuccess: Bool = false
    @State var maxSize: CGFloat = 512
    @State var currentLora: LoraModel?
    @State var loras: [LoraModel] = []
    @State var denoisingStrength: Double = 0.5
    
    var body: some View {
        VStack {
            VStack {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if loading {
                    ProgressView("Loadingggg")
                }
                
                if let image {
                    Text("\(maxSize)")
                    Slider(value: $maxSize, in: 128...1536) {
                        Text("Size Scale")
                    } minimumValueLabel: {
                        Text("128")
                    } maximumValueLabel: {
                        Text("1536")
                    }
                    
                    Text("\(denoisingStrength)")
                    Slider(value: $denoisingStrength, in: 0...1, step: 0.05) {
                        Text("denoisingStrength")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("1")
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(loras.indices, id: \.self) { index in
                                Button {
                                    currentLora = loras[index]
                                } label: {
                                    Text("\(loras[index].alias)")
                                        .font(.system(size: 18))
                                        .foregroundStyle(currentLora == loras[index] ? .yellow : .gray)
                                }
                            }
                        }
                    }
                    
                    
                    Button {
                        guard let selectedImage else { return }
                        loading = true
                        self.image = nil
                        let size = resizeCGSize(selectedImage.size, maxSize: maxSize)
                        print(selectedImage.size)
                        print(size)
                        print(denoisingStrength)
                        let model = ImageToImageModel(
                            prompt: currentLora != nil ? "<lora:\(currentLora?.alias ?? ""):1>" : "",
                            width: Int(size.width),
                            height: Int(size.height),
                            denoisingStrength: denoisingStrength,
                            initImages: [imageBase64]
                        )
                        Api.shared.imageToImage(for: model) { response in
                            loading = false
                            if let response {
                                if let uiImage = imageFromBase64(base64String: response.images.first ?? "") {
                                    DispatchQueue.main.async {
                                        self.selectedImage = uiImage
                                        self.image = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Image to image")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        if let selectedImage {
                            CustomPhotoAlbum.save(image: .normal(selectedImage)) { error in
                                if let error {
                                    print("error")
                                } else {
                                    alertSaveSuccess = true
                                }
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }

                }
            }
            
            Button("Select Image") {
                self.isShowingImagePicker = true
            }
        }
        .onAppear {
            Api.shared.getLoraList { loras in
                DispatchQueue.main.async {
                    self.loras = loras
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isShowingImagePicker)
        }
        .onChange(of: selectedImage) { _ in
            loadImage()
        }
        .toast(isPresenting: $alertSaveSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green))
        }
        
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
        
        // Convert the UIImage to Data
        if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
            // Convert Data to base64 string
            let base64String = imageData.base64EncodedString()
            self.imageBase64 = base64String
        }
    }
    
    func resizeCGSize(_ size: CGSize, maxSize: CGFloat) -> CGSize {
        let widthRatio = maxSize / size.width
        let heightRatio = maxSize / size.height
        var newSize: CGSize

        if widthRatio < heightRatio {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        } else {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }

        return newSize
    }
}

#Preview {
    ImageToImageView()
}
