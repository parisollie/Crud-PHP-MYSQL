//
//  ImagePicker.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 29/07/24.
//

import SwiftUI
//Vid 272,libreria para las fotos
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image : UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        //Vid 271,para poder las fotos
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(conexion: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let conexion : ImagePicker
        //Vid 271,ponemos nuestra conexion
        init(conexion: ImagePicker){
            self.conexion = conexion
        }
        //Vid 271,ponemos nuestro metodo
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            //Vid 271,el primero que encuentres
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                //Vid 271, el error es el gioen bajo _
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.conexion.image = image as? UIImage
                }
            }
            
            
        }
        
        
    }
    
    
}
