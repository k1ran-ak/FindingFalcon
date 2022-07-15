//
//  ViewController.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var PlanetsCVC: UICollectionView!
    var planetList = [Planet]()
    var vehicleList = [Vehicle]()
    lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        PlanetsCVC.dataSource = self
        PlanetsCVC.register(UINib(nibName: "SelectionCVC", bundle: nil), forCellWithReuseIdentifier: "SelectionCVC")
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
        }
        self.PlanetsCVC.reloadData()
        
    }
    
    //MARK: - CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCVC", for: indexPath) as! SelectionCVC
        cell.configureCell(planets: planetList,vehicles: vehicleList)
        return cell
    }
    
    @IBAction func resetActn(_ sender: Any) {
        getData()
    }
    @IBAction func findFalconActn(_ sender: Any) {
        
    }
}

