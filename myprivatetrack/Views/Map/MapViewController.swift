//
//  MapViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var headerView = UIView()
    var mapView : MKMapView!
    var mapLoaded = false
    var location: CLLocation? = nil
    var radius : CLLocationDistance = 10000
    
    override func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.enableAnchors()
        headerView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        headerView.setTopAnchor(guide.topAnchor,padding: .zero)
        headerView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, padding: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, padding: defaultInsets)
        let toggleStyleButton = IconButton(icon: "map")
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        let coord = LocationService.shared.location.coordinate
        location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        mapView.centerToLocation(location!, regionRadius: radius)
        view.addSubview(mapView)
        mapView.enableAnchors()
        mapView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        mapView.setTopAnchor(headerView.bottomAnchor, padding: 1)
        mapView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        mapView.setBottomAnchor(guide.bottomAnchor, padding: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if mapLoaded{
            mapView.removeAnnotations(mapView.annotations)
            assertMapPins()
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        print("finishedLoadingMap")
        mapLoaded = true
        assertMapPins()
    }
    
    func assertMapPins(){
        print("assertMapPins")
        for day in dataContainer.days{
            for entry in day.entries{
                if entry.saveLocation{
                    let positionPin = MKPointAnnotation()
                    positionPin.title = entry.creationDate.dateTimeString()
                    positionPin.coordinate = entry.location.coordinate
                    mapView.addAnnotation(positionPin)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        print("didSelect")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView){
        print("didDeselect")
    }
    
    @objc func toggleMapStyle() {
        if mapView.mapType == .satellite{
            mapView.mapType = .standard
        }
        else{
            mapView.mapType = .satellite
        }
    }
    
    @objc func showInfo(){
        let infoController = MapInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func takeScreenshot(callback: @escaping (_ result: UIImage?) -> Void){
        let options = MKMapSnapshotter.Options()
        options.camera = self.mapView.camera
        options.region = self.mapView.region
        options.mapType = self.mapView.mapType
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { snapshot, error in
            if error != nil {
                print("Unable to create a map snapshot.")
                callback(nil)
            } else if let snapshot = snapshot {
                UIGraphicsBeginImageContextWithOptions(snapshot.image.size, true, snapshot.image.scale)
                snapshot.image.draw(at: CGPoint.zero)
                self.drawPins()
                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                callback(compositeImage!)
            }
        }
    }
    
    private func drawPins(){
        
    }
    
    private func drawPin(point: CGPoint, annotation: MKAnnotation) {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "snapshotUserPosition")
        annotationView.contentMode = .scaleAspectFit
        annotationView.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        annotationView.drawHierarchy(in: CGRect(
            x: point.x - annotationView.bounds.size.width / 2.0,
            y: point.y - annotationView.bounds.size.height,
            width: annotationView.bounds.width,
            height: annotationView.bounds.height), afterScreenUpdates: true)
    }
    
}