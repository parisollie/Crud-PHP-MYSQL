//
//  crud.swift
//  crudphp
//
//  Created by Paul Jaime Felix Flores on 28/07/24.
//
import Foundation
import Alamofire
import UIKit

//V-269
class Crud: ObservableObject {
    //Paso 2.0,Esto nos sirve para saber si guardo correctamente.
    @Published var mensaje = ""
    @Published var show = false
    //Paso 4.2
    @Published var posts = [Posts]()
    //paso 6.1
    var urlString = ""
    
    //V-282,Paso 6.0,add  id: String, editar: Bool
    func save(titulo: String, contenido: String, id: String, editar: Bool) {
        //Paso 2.1, guardamos nuestros parametros en variables
        let parametros: Parameters = [
            //El nombre debe ser el mismo que esta en el php.
            "titulo": titulo,
            "contenido": contenido,
            "id": id
        ]
        
        //Paso 6.2
        if editar {
            urlString = "http://localhost/proyecto/crud/edit.php"
        } else {
            urlString = "http://localhost/proyecto/crud/save.php"
        }
        
        //Paso 2.2, necesitamos nuestra url
        guard let url = URL(string: urlString) else { return }
        
        //Paso 2.3, cuando trabajamos con internet ponemos un dispatch
        DispatchQueue.main.async {
            //AF es alomo Fire
            AF.request(url, method: .post, parameters: parametros).responseData { response in
                
                //Paso 2.4
                switch response.result {
                    
                case .success(let data):
                    //Paso 2.5
                    do {
                        //Paso 2.6
                        let json = try JSONSerialization.jsonObject(with: data)
                        let resultadojson = json as! NSDictionary
                        //Paso 2.7,'respuesta viene de php'
                        guard let res = resultadojson.value(forKey: "respuesta") else { return }
                        //print(res)
                        //print("++++")
                        //V-271,paso 2.17
                        if res as! String == "success" {
                            //Paso 2.18
                            self.mensaje = "Post guardado con éxito"
                            self.show = true
                            // Actualizar la lista de posts
                            self.getData()
                        } else {
                            //Paso 2.19
                            self.mensaje = "El post no se pudo guardar"
                            self.show = true
                        }
                    } catch let error as NSError {
                        print("Error en el json", error.localizedDescription)
                        //Paso 2.20
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
    
    //V-274,Paso 3.0 para guardar la imagen
    func save2(titulo: String, contenido: String, imagen: UIImage) {
        let parametros: Parameters = [
            "titulo": titulo,
            "contenido": contenido
        ]
        //Paso 3.1
        guard let url = URL(string: "http://localhost/proyecto/crud/save.php") else { return }
        guard let imgData = imagen.jpegData(compressionQuality: 1.0) else { return }
        //nombre de la imagen con la que lo guardaremos
        let nombreImagen = UUID().uuidString
        
        //Paso 3.2
        DispatchQueue.main.async {
            // AF alomofire
            AF.upload(multipartFormData: { MultipartFormData in
                //imagen es el nombre con lo que recibiremos en php
                MultipartFormData.append(imgData, withName: "imagen", fileName: "\(nombreImagen).png", mimeType: "image/png")
                //enviamos los parametros, withName, clave valor
                for (key, val) in parametros {
                    MultipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                //Paso 3.3,la url es nuestra imagen
            }, to: url, method: .post).uploadProgress { Progress in
                //para poder el progreso en la terminal y multiplicamos por 100 para ver el porcentaje
                print(Progress.fractionCompleted * 100)
            }.response { response in
                self.mensaje = "Post guardado con éxito"
                self.show = true
                // Actualizar la lista de posts
                self.getData()
            }
        }
    }
    
    //V-277,Paso 4.1 conseguimos los datos de select de php
    func getData() {
        AF.request("http://localhost/proyecto/crud/select.php")
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    do {
                        //hacemos la decodificación del Json
                        let json = try JSONDecoder().decode([Posts].self, from: data)
                        DispatchQueue.main.async {
                            //paso 4.3
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
    
    //V-280,Paso 4.16 eliminar el post
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
                      
                        let json = try JSONSerialization.jsonObject(with: data)
                        let resultadojson = json as! NSDictionary
                        guard let res = resultadojson.value(forKey: "respuesta") else { return }
                        if res as! String == "success" {
                            self.mensaje = "Post eliminado con éxito"
                            self.show = true
                            // Actualizar la lista de posts
                            self.getData()
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
