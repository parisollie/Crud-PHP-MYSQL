//
//  DetailView.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import SwiftUI

struct DetailView: View {
    //V-279,paso 4.11
    var crudItem: Posts
    //V-280,Paso 4.15 ,Recibe la instancia de Crud desde Home
    @ObservedObject var crud: Crud
    
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
            
            //Paso 4.12,botnones
            HStack(alignment: .center) {
                Button {
                    //Paso 6.4, Guardar cambios
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
                        //Paso 4.17
                        crud.delete(id: crudItem.id, nombre_imagen: crudItem.nombre_imagen)
                        // Redirigir a Home después de eliminar
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            } // Fin HStack
            .padding()
            
            Spacer()
        }
        //Paso 4.13
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
                               nombre_imagen: "imagen_prueba.jpg"),
               crud: Crud()) // Pasar una instancia de Crud en el preview
}
