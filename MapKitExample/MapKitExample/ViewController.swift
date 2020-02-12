//
//  ViewController.swift
//  MapKitExample
//
//  Created by Stefan Herold on 14.09.17.
//  Copyright © 2017 CodingCobra. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var originalRegion: MKCoordinateRegion!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupMap() {

        map.isZoomEnabled = false
        map.showsUserLocation = true

        let recognizer = UIPinchGestureRecognizer(target: self, action:#selector(handleMapPinch(recognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(recognizer)
    }

    ///Zoom in/out map
    @objc func handleMapPinch(recognizer: UIPinchGestureRecognizer) {

        if (recognizer.state == .began) {
            originalRegion = map.region
        }

        var latdelta: Double = originalRegion.span.latitudeDelta / Double(recognizer.scale)
        var londelta: Double = originalRegion.span.longitudeDelta / Double(recognizer.scale)

        //set these constants to appropriate values to set max/min zoomscale
        latdelta = max(min(latdelta, 80), 0.02);
        londelta = max(min(londelta, 80), 0.02);

        let span = MKCoordinateSpanMake(latdelta, londelta)
        let region = MKCoordinateRegionMake(originalRegion.center, span)

        print("\(region)")

        DispatchQueue.main.async { [weak self] in
            self?.map.setRegion(region, animated: false)
        }
    }

    @IBAction func pressedOptionsButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)

        let reCenterAction = UIAlertAction(title: "Re-Center", style: .default) { [weak self] (_) in
            let coordinate = CLLocationCoordinate2D(latitude: 50, longitude: 8)
            self?.map.setCenter(coordinate, animated: false)
        }
        actionSheet.addAction(reCenterAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }
}


extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("Map Will Change")
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Map Did Change")
    }
}
