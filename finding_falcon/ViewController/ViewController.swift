//
//  ViewController.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import UIKit
import Alamofire
protocol Options {
    func getPlanetAndVehicle(selectedPlanet : Planet, selectedVehicle : Vehicle, index : Int)
}
protocol Reset {
    func reset()
}

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , Options , Reset {
   
    //MARK: - Outlets
    @IBOutlet weak var PlanetsCVC: UICollectionView!
    
    @IBOutlet weak var timeTakenLbl: UILabel!
    
    
    //MARK: - Local Variables
    
    var planetList = [Planet]()
    var vehicleList = [Vehicle]()
    var planets = [String]()
    var vehicles = [String]()
    var timeTaken = [Double]()
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        getToken()
        PlanetsCVC.dataSource = self
        PlanetsCVC.delegate = self
        PlanetsCVC.register(UINib(nibName: "SelectionCVC", bundle: nil), forCellWithReuseIdentifier: "SelectionCVC")
        timeTakenLbl.text = "Time taken : 0"
    }
    
    //MARK: - Get Data from Web
    func getData() {
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        let request = AF.request("https://findfalcone.herokuapp.com/vehicles")
        request.responseDecodable(of: Vehicles.self) { (response) in
            guard let data = response.value else { return }
            self.vehicleList = data
        }
        
        let request2 = AF.request("https://findfalcone.herokuapp.com/planets")
        request2.responseDecodable(of: Planets.self) { (response) in
            guard let data = response.value else { return }
            self.planetList = data
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.PlanetsCVC.reloadData()
        }
    }
    
    func getToken() {
        let request = AF.request("https://findfalcone.herokuapp.com/token", method: .post, parameters: [String:String](), encoder: JSONParameterEncoder.default, headers: HTTPHeaders([HTTPHeader(name: "Accept", value: "application/json")]))
        request.responseDecodable(of: [String:String].self) { (response) in
            guard let data = response.value else {return}
            guard let token = data["token"] else {return}
            self.token = token
            print("token ",token)
        }
    }
    
    func findFalcon(params : [String : Any]) {
        print(params)
        let request = AF.request("https://findfalcone.herokuapp.com/find", method: .post, parameters: params, encoding: JSONEncoding.default, headers: HTTPHeaders([HTTPHeader(name: "Accept", value: "application/json")]))
        request.responseDecodable(of: [String:String].self) { (response) in
            guard let data = response.value else {return}
            guard let status = data["status"] else {return}
            var planetName = ""
            if status == "true" {
                 planetName = data["planet"] ?? ""
            } else {
                print("falcon not found")
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MissionResultVC") as! MissionResultVC
            vc.isSuccess = status == "true" ? true : false
            vc.planet = planetName
            var totalTime = 0.0
            self.timeTaken.forEach { value in
                totalTime += value
            }
            vc.timeTaken = totalTime
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCVC", for: indexPath) as! SelectionCVC
        cell.configureCell(planets: planetList,vehicles: vehicleList, index: indexPath.row,token: token)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.PlanetsCVC.frame.width * 0.8 , height: self.PlanetsCVC.frame.width - 10)
    }
    
  
    
    @IBAction func resetActn(_ sender: Any) {
        self.reset()
    }
    
    @IBAction func findFalconActn(_ sender: Any) {
        
        if planets.count != 4 || vehicles.count != 4 {
            let alert = UIAlertController(title: "Finding Falcon", message: "Please fill all the details for the Exploration", preferredStyle: .alert)
            self.present(alert, animated: true)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        } else {
            self.findFalcon(params: ["token": self.token, "planet_names" : planets, "vehicle_names" : vehicles])
        }
    }
    
    
    //MARK: - Protocol Functions
    func getPlanetAndVehicle(selectedPlanet: Planet, selectedVehicle: Vehicle, index : Int) {
      
        if planets.indices.contains(index) || vehicles.indices.contains(index){
            planets[index] = selectedPlanet.name
            vehicles[index] = selectedVehicle.name
            timeTaken[index] = Double(selectedPlanet.distance / selectedVehicle.speed)
        } else {
            planets.append(selectedPlanet.name)
            vehicles.append(selectedVehicle.name)
            timeTaken.append(Double(selectedPlanet.distance / selectedVehicle.speed))
        }
            print("Selected Planet: \(selectedPlanet), Selected Vehicle: \(selectedVehicle)")
        var totalTime = 0.0
        timeTaken.forEach { value in
            totalTime += value
        }
        if planets.count > 0 {
            timeTakenLbl.text = "Time taken : \(totalTime)"
        }
        
       
    }
    
    func reset() {
        self.planets.removeAll()
        self.vehicles.removeAll()
        self.timeTaken.removeAll()
        self.timeTakenLbl.text = "Time taken : 0"
        PlanetsCVC.reloadData()
    }
    
}

