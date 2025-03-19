//
//  EditView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//

import SwiftUI

//vid 281
struct EditView: View {
    var crudItem: Posts
    //Vid 282
    @StateObject var crud = Crud()
    //Vid 282
    @State private var titulo = ""
    @State private var contenido = ""
    
    // Nuevo: Para regresar a la pantalla anterior
    @Environment(\.presentationMode) var presentationMode
    
    // Nuevo: Callback para notificar a DetailView que la edición fue exitosa
    var onEditSuccess: (() -> Void)?
    
    var body: some View {
        Form {
            TextField("Titulo", text: $titulo)
                .onAppear {
                    titulo = crudItem.titulo
                }
            TextEditor(text: $contenido)
                .onAppear {
                    contenido = crudItem.contenido
                }
            Button {
                //Vid 282
                crud.save(titulo: titulo, contenido: contenido, id: crudItem.id, editar: true)
                
                // Nuevo: Cerrar EditView y notificar a DetailView
                self.presentationMode.wrappedValue.dismiss()
                self.onEditSuccess?()
            } label: {
                Text("Editar post")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    EditView(crudItem: Posts(id: "1",
                            titulo: "Título de prueba",
                            contenido: "Contenido de prueba",
                            imagen: "imagen_url",
                            nombre_imagen: "imagen_prueba.jpg"))
}
