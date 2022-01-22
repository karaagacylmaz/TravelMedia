//
//  MapViewController.swift
//  TravelMedia
//
//  Created by Yılmaz Karaağaç on 1/22/22.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var saveButton: UIButton!
    
    var locationManager = CLLocationManager()
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUserInteractiveImageView()
        configureMapAndLocation()
        addLongPressGestureToMapView()
    }
    
    // MARK: - User Interacted ImageView
    func makeUserInteractiveImageView() {
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
            self.selectImage(sourceType: .photoLibrary) //select from library
        }
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            print("Camera Tapped")
            self.selectImage(sourceType: .camera) // take photo by camera
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
    
    // MARK: - Configure Map and Location
    
    func configureMapAndLocation() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    func addLongPressGestureToMapView() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3 // or 2 second for pin to map
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            print(chosenLatitude, chosenLongitude)
            
            addPin(coordinate: touchedCoordinates)
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = nameTextField.text
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - Core Data Usage
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let context = getContext()
        setPlaceData(context)
        saveChanges(context)
        goBack()
    }
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }
    
    func setPlaceData(_ context: NSManagedObjectContext) {
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context)
        newPlace.setValue(nameTextField.text, forKey: "galleryName")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        let imageData = imageView.image?.jpegData(compressionQuality: 0.5)
        newPlace.setValue(imageData, forKey: "image")
    }
    
    func saveChanges(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            print("success save")
        } catch {
            print("error save")
        }
    }
    
    func goBack() {
        NotificationCenter.default.post(name: NSNotification.Name("newdata"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}
