//
//  ViewController.swift
//  AmbulanzDemo
//
//  Created by Schechter, David on 8/1/16.
//  Copyright © 2016 DavidSchechter. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SocketIOClientSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private let socket = SocketIOClient(socketURL: NSURL(string: "https://codesample.ambulnz-dev.com/socket.io")!)
    private var markerDic:Dictionary = [String:GMSMarker]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //Controls whether the My Location dot and accuracy circle is enabled.
        self.mapView.myLocationEnabled = true
        //Controls the type of map tiles that should be displayed.
        self.mapView.mapType = kGMSTypeNormal
        //Shows the compass button on the map
        self.mapView.settings.compassButton = true
        //Shows the my location button on the map
        self.mapView.settings.myLocationButton = true
        
        self.socketHandler()
        
        socket.connect()
        
    }
    
    
    func socketHandler()
    {
        socket.on("location-updated") {data, ack in
            if let dic = data[0] as? NSDictionary
            {
                if self.markerDic.count == 0
                {
                    if let latitude = dic["latitude"] as? Double, longitude = dic["longitude"] as? Double, unitId = dic["unitId"] as? String
                    {
                        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        let updatedCamera: GMSCameraUpdate = GMSCameraUpdate.setTarget(coordinate, zoom: 10.0)
                        self.mapView.animateWithCameraUpdate(updatedCamera)
                        let marker = GMSMarker(position: coordinate)
                        marker.title = unitId
                        marker.map = self.mapView
                        if let status = dic["status"] as? String
                        {
                            if status == "PENDING_ONLINE"
                            {
                                marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
                            }
                            else
                            {
                                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                            }
                        }
                        else
                        {
                            marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                        }
                        self.markerDic[unitId] = marker
                    }
                }
                else
                {
                    if self.markerDic[dic["unitId"] as! String] == nil
                    {
                        if let latitude = dic["latitude"] as? Double, longitude = dic["longitude"] as? Double, unitId = dic["unitId"] as? String
                        {
                            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                            let marker = GMSMarker(position: coordinate)
                            marker.title = unitId
                            marker.map = self.mapView
                            if let status = dic["status"] as? String
                            {
                                if status == "PENDING_ONLINE"
                                {
                                    marker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
                                }
                                else
                                {
                                    marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                                }
                            }
                            else
                            {
                                marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                            }
                            self.markerDic[unitId] = marker
                        }
                    }
                    else
                    {
                        if let latitude = dic["latitude"] as? Double, longitude = dic["longitude"] as? Double, unitId = dic["unitId"] as? String
                        {
                            let marker = self.markerDic[unitId]
                            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                            if let status = dic["status"] as? String
                            {
                                if status == "PENDING_ONLINE"
                                {
                                    marker?.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
                                }
                                else
                                {
                                    marker?.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                                }
                            }
                            else
                            {
                                marker?.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
                            }
                            UIView.animateWithDuration(1.0, animations: { () -> Void in
                                marker?.position = coordinate
                                }, completion: {(finished: Bool) -> Void in
                                    // Stop tracking view changes to allow CPU to idle.
                                    marker?.tracksViewChanges = false
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

