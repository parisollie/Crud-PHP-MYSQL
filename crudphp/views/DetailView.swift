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
    
    // Campos de edición
    @State private var titulo = ""
    @State private var contenido = ""
    
    //Alerta eliminar
    @State private var showDeleteAlert = false
    
    // Nuevo: Para regresar a la pantalla anterior
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center) {
            // Campos de edición
            TextField("Título", text: $titulo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onAppear {
                    // Inicializar los campos con los valores actuales
                    titulo = crudItem.titulo
                    contenido = crudItem.contenido
                }
            
            TextEditor(text: $contenido)
                .frame(height: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            
            HStack(alignment: .center) {
                Button {
                    // Guardar cambios
                    crud.save(titulo: titulo, contenido: contenido, id: crudItem.id, editar: true)
                    
                    // Redirigir a Home después de guardar
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Guardar")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                }

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
                        // Redirigir a Home después de eliminar
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            } // Fin HStack
            .padding()
            
            Spacer()
        }
        .padding(.all)
        .navigationTitle("Editar Post")
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
