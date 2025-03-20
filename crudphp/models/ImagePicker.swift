//
//  ImagePicker.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 29/07/24.
//

import SwiftUI
//V-272,Paso 2.23 libreria para las fotos, lo podemos guardar 
import PhotosUI

//Paso 2.24
struct ImagePicker: UIViewControllerRepresentable {
    
    //Paso 2.25
    @Binding var image : UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        //Paso 2.26
        var config = PHPickerConfiguration()
        //Paso 2.27,para poder agarrar las fotos
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        //Ponemos los delegados
        picker.delegate = context.coordinator
        
        return picker
    }
    
    //Pado 2.28
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    //Pado 2.29
    func makeCoordinator() -> Coordinator {
        Coordinator(conexion: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let conexion : ImagePicker
        //Paso 2.30,ponemos nuestra conexion
        init(conexion: ImagePicker){
            self.conexion = conexion
        }
        //Paso 2.31,ponemos nuestro método
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            //el primero que encuentres
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                //el error es el guion bajo _
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.conexion.image = image as? UIImage
                }
            }
        }
    }//Fin Class Cordinator
}
