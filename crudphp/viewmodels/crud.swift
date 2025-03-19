//
//  crud.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import Foundation
import Alamofire
import UIKit

//Vid 269
class Crud: ObservableObject {
    //Esto nos sirve para saber si guardo correctamente
    @Published var mensaje = ""
    @Published var show = false
    //Vid 277,
    @Published var posts = [Posts]()
    var urlString = ""
    
    func save(titulo: String, contenido: String, id: String, editar: Bool) {
        //Vid 269, guardamos nuestros parametros en variables
        let parametros: Parameters = [
            "titulo": titulo,
            "contenido": contenido,
            "id": id
        ]
        //Vid 282
        if editar {
            urlString = "http://localhost/proyecto/crud/edit.php"
        } else {
            urlString = "http://localhost/proyecto/crud/save.php"
        }
        //Vid 269, necesitamos nuestra url
        guard let url = URL(string: urlString) else { return }
        //Vid 269, cuando trabajamos con internet ponemos un dispatch
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parametros).responseData { response in
                //Vid 269
                switch response.result {
                case .success(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data)
                        let resultadojson = json as! NSDictionary
                        guard let res = resultadojson.value(forKey: "respuesta") else { return }
                        //Vid 271
                        if res as! String == "success" {
                            self.mensaje = "Post guardado con éxito"
                            self.show = true
                            self.getData() // Actualizar la lista de posts
                        } else {
                            self.mensaje = "El post no se pudo guardar"
                            self.show = true
                        }
                    } catch let error as NSError {
                        print("Error en el json", error.localizedDescription)
                        self.mensaje = "El post no se pudo guardar"
                        self.show = true
                    }
                case .failure(let error):
                    print(error)
                    self.mensaje = "El post no se pudo guardar"
                    self.show = true
                }
            }
        }
    }
    
    //Vid 274, para guardar la imagen
    func save2(titulo: String, contenido: String, imagen: UIImage) {
        let parametros: Parameters = [
            "titulo": titulo,
            "contenido": contenido
        ]
        
        guard let url = URL(string: "http://localhost/proyecto/crud/save.php") else { return }
        //Vid 274
        guard let imgData = imagen.jpegData(compressionQuality: 1.0) else { return }
        //Vid 274, nombre de la imagen con la que lo guardaremos
        let nombreImagen = UUID().uuidString
        
        DispatchQueue.main.async {
            //Vid 274, AF alomofire
            AF.upload(multipartFormData: { MultipartFormData in
                //Vid 274, imagen es el nombre con lo que recibiremos en php
                MultipartFormData.append(imgData, withName: "imagen", fileName: "\(nombreImagen).png", mimeType: "image/png")
                //Vid 274, enviamos los parametros, withName, clave valor
                for (key, val) in parametros {
                    MultipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //Vid 274, la url es nuestra imagen
            }, to: url, method: .post).uploadProgress { Progress in
                //Vid 274, para poder el progreso en la terminal y multiplicamos por 100 para ver el porcentaje
                print(Progress.fractionCompleted * 100)
            }.response { response in
                self.mensaje = "Post guardado con éxito"
                self.show = true
                self.getData() // Actualizar la lista de posts
            }
        }
    }
    
    //Vid 277, conseguimos los datos de select de php
    func getData() {
        AF.request("http://localhost/proyecto/crud/select.php")
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        //Vid 277, hacemos la decodificación del Json
                        let json = try JSONDecoder().decode([Posts].self, from: data)
                        DispatchQueue.main.async {
                            print(json)
                            self.posts = json
                        }
                    } catch let error as NSError {
                        print("error al mostrar json", error.localizedDescription)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    //Vid 280, eliminar el post
    func delete(id: String, nombre_imagen: String) {
        let parametros: Parameters = [
            "id": id,
            "nombre_imagen": nombre_imagen
        ]
        
        guard let url = URL(string: "http://localhost/proyecto/crud/delete.php") else { return }
        
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parametros).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        //Vid 269
                        let json = try JSONSerialization.jsonObject(with: data)
                        let resultadojson = json as! NSDictionary
                        guard let res = resultadojson.value(forKey: "respuesta") else { return }
                        if res as! String == "success" {
                            self.mensaje = "Post eliminado con éxito"
                            self.show = true
                            self.getData() // Actualizar la lista de posts
                        } else {
                            self.mensaje = "El post no se pudo eliminar"
                            self.show = true
                        }
                    } catch let error as NSError {
                        print("Error en el json", error.localizedDescription)
                        self.mensaje = "El post no se pudo eliminar"
                        self.show = true
                    }
                case .failure(let error):
                    print(error)
                    self.mensaje = "El post no se pudo eliminar"
                    self.show = true
                }
            }
        }
    }
}
