//
//  PostView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import SwiftUI

struct PostView: View {
    //V-270,paso 2.10
    @ObservedObject var crud: Crud // Recibe la instancia de Crud desde Home
    //V-271,paso 2.13
    @State private var titulo = ""
    @State private var contenido = ""
    //V-273,Paso 2.32 Para abrir la libreria
    @State private var showImagePIcker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    //Paso 2.34,función para cargar la imagen
    func loadImage() {
        guard let inputImage = inputImage else { return }
        //integramos la imagén para que se muestre en la vista
        image = Image(uiImage: inputImage)
    }

    // Añadido: Usamos presentationMode para cerrar la vista actual
    @Environment(\.presentationMode) var presentationMode

    //Paso 2.10
    var body: some View {
        //paso 2.14, pone Form
        VStack {
            TextField("Titulo", text: $titulo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
       
            
            TextEditor(text: $contenido)
                .frame(height: 150)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                .padding()
            
            //Paso 2.39
            image?
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
           
            //V-274,paso 2.15
            Button {
                //V-274,paso 3.4 aqui nunca cargamos una imagen y sino mandaremos cuando esocgimos una imagen
                //V-282
                if image == nil {
                    //Paso 2.12
                    //Paso 6.3, ponemos el editar
                    crud.save(titulo: titulo, contenido: contenido, id: "", editar: false)
                } else {
                    crud.save2(titulo: titulo, contenido: contenido, imagen: inputImage!)
                }
                //Paso 2.16,despues de guardar queremos que todo este vacío
                titulo = ""
                contenido = ""
                //paso 3.5
                image = nil
                
                // Refrescar la lista de posts en Home
                crud.getData()
                
                // Redirigir a Home después de guardar
                presentationMode.wrappedValue.dismiss()
            } label: {
                //Paso 2.11
                Text("Guardar post")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            //Paso 2.22
            .alert(crud.mensaje, isPresented:$crud.show){
                Button("Aceptar",role:.none){}
            }
            Spacer()
        }
        //Paso 2.21
        .padding()
        .navigationTitle("Alta post")
        //Paso 2.35
        .toolbar {
            Button {
                //Paso 2.36,ponemos la imagen para que se muestre
                showImagePIcker = true
            } label: {
                Image(systemName: "camera")
            }
        }
        //Paso 2.37,cuando inputImage cambie ponemos la imagen
        .onChange(of: inputImage) { _ in
            //cargamos la funcion load image
            loadImage()
        }
        //Paso 2.38
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
