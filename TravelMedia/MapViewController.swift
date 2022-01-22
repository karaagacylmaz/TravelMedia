//
//  MapViewController.swift
//  TravelMedia
//
//  Created by Yılmaz Karaağaç on 1/22/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUserIntercativeImageView()
        
    }
    
    // MARK: - User Interacted ImageView
    func makeUserIntercativeImageView() {
        imageView.isUserInteractionEnabled = true
        addTapGestureToImageView()
    }
    
    func addTapGestureToImageView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func imageViewTapped() {
        print("image tapped")
        makeAlert()
    }
    
    // MARK: - Pick or Take Photo by Alert
    func makeAlert() {
        let alert = UIAlertController(title: "Media Source", message: "Use Camera or Library", preferredStyle: UIAlertController.Style.alert)
        let libraryButton = UIAlertAction(title: "Library", style: UIAlertAction.Style.default) { UIAlertAction in
            print("Library Tapped")
        }
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            print("Camera Tapped")
        }
        
        alert.addAction(libraryButton)
        alert.addAction(cameraButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectImage(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // Inherited from UIImagePickerControllerDelegate.imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage // or original image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
    
}
