//
//  EditView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//

import SwiftUI

/*struct EditView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}*/
//vid 281 
struct EditView: View {
    
    var crudItem : Posts
    //Vid 282 
    @StateObject var crud = Crud()
    //Vid 282 
    @State private var titulo = ""
    @State private var contenido = ""
    
    var body: some View {
        Form{
            TextField("Titulo", text: $titulo)
                .onAppear{
                    titulo = crudItem.titulo
                }
            TextEditor(text: $contenido)
                .onAppear{
                    contenido = crudItem.contenido
                }
            Button {
                //Vid 282
                crud.save(titulo: titulo, contenido: contenido, id: crudItem.id, editar: true)
            } label: {
                Text("Editar post")
            }

        }
    }
}


#Preview {
    DetailView(crudItem: Posts(id: "1",
                               titulo: "Título de prueba",
                               contenido: "Contenido de prueba",
                               imagen: "imagen_url",
                               nombre_imagen: "imagen_prueba.jpg"))
}

