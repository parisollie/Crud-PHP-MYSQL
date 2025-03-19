//
//  Home.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import SwiftUI

struct Home: View {
    //Vid 277,
    @StateObject var crud = Crud() // Instancia única de Crud
    
    var body: some View {
        //Vid 270,
        NavigationView {
            List {
                //Vid 278,
                ForEach(crud.posts, id: \.id) { item in
                    //Vid 279
                    NavigationLink(destination: DetailView(crudItem: item, crud: crud)) {
                        CeldaView(imagen: item.imagen, titulo: item.titulo, contenido: item.contenido)
                    }
                }
            }
            //Vid 278
            .navigationTitle("CRUD")
            .listStyle(.plain)
            //Vid 270,
            .toolbar {
                NavigationLink(destination: PostView(crud: crud)) { // Pasar la instancia de Crud a PostView
                    Image(systemName: "plus")
                }
                //Vid 277,
            }
            .onAppear {
                crud.getData() // Refrescar datos al aparecer
            }
        }
    }
}

//Vid 278, celda para mostrar las imagenes
struct CeldaView: View {
    var imagen: String
    var titulo: String
    var contenido: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(titulo).font(.largeTitle).bold()
            AsyncImage(url: URL(string: imagen)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.red
            }
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 10)
            Text(contenido).font(.body)
        }
    }
}

#Preview {
    Home()
}
