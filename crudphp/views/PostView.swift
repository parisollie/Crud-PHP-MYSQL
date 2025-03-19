//
//  PostView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import SwiftUI

struct PostView: View {
    //Vid 270
    @ObservedObject var crud: Crud // Recibe la instancia de Crud desde Home
    //Vid 271
    @State private var titulo = ""
    @State private var contenido = ""
    //Vid 273
    //Para abrir la libreria
    @State private var showImagePIcker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    //Vid 273,funcion para cargar la imagen
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //Vid 273,integramos la imagen
        image = Image(uiImage: inputImage)
    }

    // Añadido: Usamos presentationMode para cerrar la vista actual
    @Environment(\.presentationMode) var presentationMode

    //Vid 270
    var body: some View {
        //Vid 271
        VStack {
            TextField("Titulo", text: $titulo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $contenido)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding()
            
            //Vid 273
            image?
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            //Vid 274
            Button {
                //Vid 274,aqui nunca cargamos una imagen y sino mandaremos cuando esocgimos una imagen
                //Vid 282
                if image == nil {
                    crud.save(titulo: titulo, contenido: contenido, id: "", editar: false)
                } else {
                    crud.save2(titulo: titulo, contenido: contenido, imagen: inputImage!)
                }
                //Vid 271,despues de guardar queremos que todo este vacío
                titulo = ""
                contenido = ""
                image = nil
                
                // Refrescar la lista de posts en Home
                crud.getData()
                
                // Redirigir a Home después de guardar
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Guardar post")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .navigationTitle("Alta post")
        //Vid 273
        .toolbar {
            Button {
                //Vid 273,ponemos la imagen para que se muestre
                showImagePIcker = true
            } label: {
                Image(systemName: "camera")
            }
        }
        //Vid 273,cuando inputImage cambie ponemos la imagen
        .onChange(of: inputImage) { _ in
            loadImage()
        }
        .sheet(isPresented: $showImagePIcker) {
            ImagePicker(image: $inputImage)
        }
    }
}

#Preview {
    NavigationView {
        PostView(crud: Crud()) // Pasar una instancia de Crud en el preview
    }
}
