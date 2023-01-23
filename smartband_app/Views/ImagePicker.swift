//
//  ImagePicker.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import Foundation
import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selected_image: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    var source_type: UIImagePickerController.SourceType = .photoLibrary
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source_type
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
         
            var parent: ImagePicker
         
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
        
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    parent.selected_image = image
                }
         
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
