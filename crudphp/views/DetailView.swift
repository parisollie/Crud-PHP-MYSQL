//
//  DetailView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//

import SwiftUI

struct DetailView: View {
    //Vid 279
    var crudItem: Posts
    //Vid 280
    @StateObject var crud = Crud()
    //Vid 281
    @State private var show = false
    
    //Alerta eliminar
    @State private var showDeleteAlert = false
    
    // Nuevo: Bandera para redirigir a Home después de eliminar
    @State private var redirectToHome = false
    
    // Nuevo: Para regresar a la pantalla anterior
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center) {
            //Vid 279,ponemos el titulo vacío
            CeldaView(imagen: crudItem.imagen, titulo: "", contenido: crudItem.contenido)
            
            HStack(alignment: .center) {
                Button {
                    //Vid 281
                    show.toggle()
                } label: {
                    Text("Editar")
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $show) {
                    EditView(crudItem: crudItem)
                }

                Button("Eliminar") {
                    showDeleteAlert.toggle()
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .alert("¿Quieres eliminarlo?", isPresented: $showDeleteAlert) {
                    Button("Cancelar", role: .cancel) {}
                    Button("Eliminar", role: .destructive) {
                        // Eliminar el post
                        crud.delete(id: crudItem.id, nombre_imagen: crudItem.nombre_imagen)
                        
                        // Nuevo: Redirigir a Home después de eliminar
                        DispatchQueue.main.async {
                            self.presentationMode.wrappedValue.dismiss() // Regresa a la pantalla anterior
                        }
                    }
                }
            } // Fin HStack
            
            Spacer()
        }
        .padding(.all)
        .navigationTitle(crudItem.titulo)
        .alert(crud.mensaje, isPresented: $crud.show) {
            Button("Aceptar", role: .none) {}
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
