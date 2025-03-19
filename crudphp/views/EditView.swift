//
//  EditView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//

import SwiftUI

/*vid 281
struct EditView: View {
    var crudItem: Posts
    //Vid 282
    @ObservedObject var crud: Crud // Recibe la instancia de Crud desde Home
    
    //Vid 282
    @State private var titulo = ""
    @State private var contenido = ""
    
    //Alerta eliminar
    @State private var showDeleteAlert = false
    
    // Nuevo: Para regresar a la pantalla anterior
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Titulo", text: $titulo)
                .onAppear {
                    titulo = crudItem.titulo
                    contenido = crudItem.contenido
                }
                .onChange(of: titulo) { _ in
                    checkForChanges()
                }
            
            TextEditor(text: $contenido)
                .onAppear {
                    contenido = crudItem.contenido
                }
                .onChange(of: contenido) { _ in
                    checkForChanges()
                }
            
            Button {
                //Vid 282
                crud.save(titulo: titulo, contenido: contenido, id: crudItem.id, editar: true)
                
                // Nuevo: Cerrar EditView y notificar a DetailView
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Editar post")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .disabled(titulo == crudItem.titulo && contenido == crudItem.contenido) // Desactivar si no hay cambios
            
            // Restaurar la función de eliminar
            Button {
                showDeleteAlert.toggle()
            } label: {
                Text("Eliminar")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .alert("¿Quieres eliminarlo?", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Eliminar", role: .destructive) {
                    crud.delete(id: crudItem.id, nombre_imagen: crudItem.nombre_imagen)
                    // Refrescar la lista de posts en Home
                    crud.getData()
                    // Redirigir a Home después de eliminar
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    // Función para verificar si hay cambios
    private func checkForChanges() {
        // Habilitar o deshabilitar el botón de editar según los cambios
    }
}

#Preview {
    EditView(crudItem: Posts(id: "1",
                            titulo: "Título de prueba",
                            contenido: "Contenido de prueba",
                            imagen: "imagen_url",
                            nombre_imagen: "imagen_prueba.jpg"),
             crud: Crud()) // Pasar una instancia de Crud en el preview
}*/

