//
//  Home.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import SwiftUI

struct Home: View {
    //Paso 4.5
    @StateObject var crud = Crud()
    
    var body: some View {
        //Paso 2.8,
        NavigationView {
            List {
                //Paso 4.8
                ForEach(crud.posts, id: \.id) { item in
                    //V-279,paso 4.14, para dirigirnos a Detail
                    NavigationLink(destination: DetailView(crudItem: item, crud: crud)) {
                        //Paso 4.9
                        CeldaView(imagen: item.imagen, titulo: item.titulo, contenido: item.contenido)
                    }
                }
            }
            //Paso 4.10
            .navigationTitle("CRUD")
            //Para que no aparezca el recuadro
            .listStyle(.plain)
            //Paso 2.9
            .toolbar {
                NavigationLink(destination: PostView(crud: crud)) { // Pasar la instancia de Crud a PostView
                    Image(systemName: "plus")
                }
            }
            //V-277,Paso 4.4
            .onAppear {
                //paso 4.6
                crud.getData() // Refrescar datos al aparecer
            }
        }
    }
}

//V-278,paso 4.7 celda para mostrar las imagenes
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
                Color.purple
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
