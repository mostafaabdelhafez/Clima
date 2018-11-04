//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController,CLLocationManagerDelegate,changecitydelegate {
    
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    let locationmanager=CLLocationManager()
    let weathermodel=WeatherDataModel()

    //TODO: Declare instance variables here
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationmanager.delegate=self
        locationmanager.desiredAccuracy=kCLLocationAccuracyHundredMeters
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
        //TODO:Set up the location manager here.
    
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    

    func getweatherdata(url:String,parameters:[String:String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
          
            response in
            if response.result.isSuccess{
                
                print("success got the weather data")
                let weatherjson:JSON=JSON(response.result.value!)
                print(weatherjson)
               self.updateweatherdata(json:weatherjson)
            }
            else{
                self.cityLabel.text="connection error"
                
            }
        }
        
        
    }
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    
    func updateweatherdata(json:JSON){
        
        
        if  let temp=json["main"]["temp"].double{
        weathermodel.temprature=Int(temp-273.15)
        weathermodel.cityname=json["name"].stringValue
        weathermodel.condition=json["weather"][0]["id"].intValue
        weathermodel.weathername=weathermodel.updateWeatherIcon(condition:weathermodel.condition)
            updateuiweather()
        }
        else{
            
            
            cityLabel.text="weather unavailable"
        }
    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateuiweather(){
        
        
        cityLabel.text=weathermodel.cityname
        temperatureLabel.text="\(weathermodel.temprature)"
        weatherIcon.image=UIImage(named:weathermodel.weathername)
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location=locations[locations.count-1]
        if location.horizontalAccuracy>0{
            locationmanager.stopUpdatingLocation()
            locationmanager.delegate=nil
        let latitude=String(location.coordinate.latitude)
            let longtude=String(location.coordinate.longitude)
            
        
        let param:[String:String]=["lat":latitude,"lon":longtude,"appid":APP_ID]
            getweatherdata(url:WEATHER_URL,parameters:param)
        }}
    
    
    
    //Write the didFailWithError method here:
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        cityLabel.text="location unvalid"
    }

    
    //MARK: - Change City Delegate methods
    func getcityname(city: String) {
        let params:[String:String]=["q":city,"appid":APP_ID]
        getweatherdata(url: WEATHER_URL, parameters: params)
    }
    /***************************************************************/
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="changeCityName"{
        
            let destvc=segue.destination as! ChangeCityViewController
            destvc.changecity=self
            
        }
        
        
        
        
    }
    
    
    
    
}


