//
//  ViewController.swift
//  DogOrNotToDog
//
//  Created by Eslam Fathy on 5/13/20.
//  Copyright © 2020 Eslam Fathy. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageArea: UIImageView!
    
    @IBOutlet weak var resultLable: UILabel!
    
    let imagerPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagerPicker.delegate = self
        imagerPicker.sourceType = .camera
        imagerPicker.allowsEditing = false
        self.navigationItem.title = "The Detector" 
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagerPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageArea.image = selectedImage
            if let ciimage = CIImage(image: selectedImage) {
                detect(ciImage: ciimage)
            }
        }
        imagerPicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func detect(ciImage : CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("could not load the model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request , error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("request results error")
            }
            if let one = results.first {
                print(one.identifier)
                self.resultLable.text = one.identifier

            }
        }
         
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    

}

