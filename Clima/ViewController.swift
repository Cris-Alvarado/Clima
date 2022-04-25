//
//  ViewController.swift
//  Clima
//
//  Created by mac19 on 17/03/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fondoClima: UIImageView!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var imagenClima: UIImageView!
    @IBOutlet weak var mensajeTemLabel: UILabel!
    @IBOutlet weak var nombreCiudadTextField: UITextField!
    
    var climaManeger = ClimaManger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        climaManeger.delegado = self
        fondoClima.image = UIImage(named: "nubes")
        nombreCiudadTextField.delegate = self
        
    }

    @IBAction func buscarBtn(_ sender: UIButton) {
        print("nombre de ciudad: \(nombreCiudadTextField.text)")
        
    }
    @IBAction func ubicacionBtn(_ sender: UIButton) {
        print("Se optuvo coordenadas ")
    }
    
    //MARK: - Metodos del UITextField
    //Identificar si presiona el boton del teclado virtual 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //print("Boton presionado")
        nombreCiudadTextField.endEditing(true)
        print(nombreCiudadTextField.text ?? "")
        return true
    }
    
    //identifica cuando el user termino de editar y se puede borrar 
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("El usuario temario de edita")
        
        climaManeger.objenerClima(nombreCiudad: nombreCiudadTextField.text ?? "Morelia")
    }
    
    //Evitar que el usuario No escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if nombreCiudadTextField.text != "" {
            return true
        }else{
            print("necesita escribir el nombre de una ciudad ")
            mensajeTemLabel.text = "Necesita escribir el nombre de una ciudad"
            nombreCiudadTextField.placeholder = "Necesitas escribir el nombre de la ciudad"
            return false
        }
    }
    
    //MARK: - ClimaManagerDlegado y sus metodos para actualizar clima y mostar el error
    
   
    
    
}

extension ViewController: ClimaManagerDelegado{
    func actualizarClima(objClima: ClimaModelo){
        DispatchQueue.main.async {
            self.temperaturaLabel.text = "\(objClima.temperaturaString)"
            self.mensajeTemLabel.text = "En \(objClima.nombreCiudad) esta inset descript"
            self.imagenClima.image = UIImage(named: "cloud.bolt")
            self.fondoClima.image = UIImage(named: "lluvia")
        }
    }
    func huboError(cualError: Error){
        DispatchQueue.main.async {
            self.mensajeTemLabel.text = "\(cualError.localizedDescription)"
        }
    }
}
