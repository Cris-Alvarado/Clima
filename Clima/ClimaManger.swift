//
//  ClimaManger.swift
//  Clima
//
//  Created by mac19 on 23/03/22.
//

import Foundation

protocol ClimaManagerDelegado {
    func actualizarClima(objClima: ClimaModelo)
    
    func huboError(cualError:Error)
}

struct  ClimaManger {
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?lat=19.70078&lon=-101.18443&appid=9591fc2c2d8b0ebc067ebd8d8759a746&units=metric&lang=es&"
    
    var delegado: ClimaManagerDelegado?
    
    func objenerClima(nombreCiudad: String){
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        print(urlString)
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        
        //1.-Crea un URL
        if let url = URL(string: urlString){
            
            //2.- Crear una URLSesion
            let session = URLSession(configuration: .default)
            
            //3.- Asigna una tarea a la sesion
            let tarea = session.dataTask(with: url){datos, respuesta, error in
                if error != nil{
                    delegado?.huboError(cualError: error!)
                    return
                }
                
                //si no hubo error
                if let datosSeguros = datos{
                    //si se crea el objClima
                    if let objClima = analizarJSON(datosClima: datosSeguros){
                        delegado?.actualizarClima(objClima: objClima)
                    }
                }
              
            }
            //4.- Comenzar la tarea
            tarea.resume()
        }
            
        
    }
    
        func analizarJSON(datosClima: Data) -> ClimaModelo?{
            let decodificador = JSONDecoder()
            do{
                let datosDecodificados = try decodificador.decode(DatosClima.self, from: datosClima)
                print(datosDecodificados.name)
                print(datosDecodificados.main.temp)
                print(datosDecodificados.weather[0].id)
                
                let condicionId = datosDecodificados.weather[0].id
                let nombreCiudad = datosDecodificados.name
                let temperatura = datosDecodificados.main.temp
               // let descripcion = datosDecodificados.weather[0].
                //let humedad = datosDecodificados.main.humidity
                
                //si se crea el objeto
                let objClima = ClimaModelo(condicionID: condicionId, nombreCiudad: nombreCiudad, temperatura: temperatura)
                // Si se crea se retorna 
                return objClima
                
               
                
                
            } catch{
                print(error)
                //si no se crea se manda nil
                delegado?.huboError(cualError: error)
                return nil
            }
        }
}

