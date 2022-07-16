//
//  SelectionCVC.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import UIKit
import Alamofire

class SelectionCVC: UICollectionViewCell ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    
//MARK: - Outlets
    
    @IBOutlet weak var planetTitleLbl: UILabel!
    @IBOutlet weak var radioButtonView: UIView!
    @IBOutlet weak var planetsTV: UITableView!
    @IBOutlet weak var planetsSearchBar: UISearchBar!
    @IBOutlet weak var radioButton1: UIButton!
    @IBOutlet weak var radioButton2: UIButton!
    @IBOutlet weak var radioButton3: UIButton!
    @IBOutlet weak var radioButton4: UIButton!
    
    //MARK: - Local Variables
    var list = Planets()
    var filteredList = [Planet]()
    var isFiltering = Bool()
    var vehicleList = Vehicles()
    var selectedPlanet : Planet?
    var selectedVehicle : Vehicle?
    var delegate : Options!
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.planetsSearchBar.delegate = self
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    func initRadioButtons() {
        let radioButtons = [radioButton1,radioButton2,radioButton3,radioButton4]
        radioButtons.enumerated().forEach({ idx,radioButton in
            radioButton?.titleLabel?.text = vehicleList[idx].name
        })
    }
    
    @IBAction func tapAction1(_ sender: Any) {
       changeButtonStatus(index: 0)
    }
    @IBAction func tapAction2(_ sender: Any) {
       
        changeButtonStatus(index: 1)
    }
    @IBAction func tapAction3(_ sender: Any) {
        changeButtonStatus(index: 2)
    }
    
    @IBAction func tapAction4(_ sender: Any) {
        changeButtonStatus(index: 3)
    }
    
    func changeButtonStatus(index : Int) {
        let radioButtons = [radioButton1,radioButton2,radioButton3,radioButton4]
        radioButtons.enumerated().forEach({ idx,radioButton in
            if idx == index {
                radioButton?.layer.borderWidth = 2.0
                radioButton?.layer.borderColor = UIColor.blue.cgColor
                selectedVehicle = vehicleList[idx]
                guard let planet = selectedPlanet, let vehicle = selectedVehicle else {return}
                delegate.getPlanetAndVehicle(selectedPlanet: planet, selectedVehicle: vehicle, index: self.index)
            } else {
                radioButton?.layer.borderWidth = 0.0
                radioButton?.layer.borderColor = nil
            }
        })
    }
    
    func configureCell(planets : Planets, vehicles : Vehicles, index : Int, token : String) {
        self.index = index
        self.planetsSearchBar.text = ""
        list = planets
        vehicleList = vehicles
        initRadioButtons()
        changeButtonStatus(index: 0)
        self.planetTitleLbl.text = "\(index+1). Planet :"
        self.planetsTV.isHidden = true
        self.planetsTV.delegate = self
        self.planetsTV.dataSource = self
        self.planetsTV.register(UINib(nibName: "PlanetsTVC", bundle: nil), forCellReuseIdentifier: "PlanetsTVC")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search for: ",searchText)
        self.planetsTV(searchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.planetsTV.isHidden = false
            self.radioButtonView.isHidden = true
            planetsTV.reloadData()
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    func planetsTV(_ searchText : String) {
        if searchText.isEmpty {
            filteredList.removeAll()
            isFiltering = false
        } else {
            filteredList = list.filter{$0.name.range(of: searchText, options: .caseInsensitive) != nil }
            isFiltering = true
            self.planetsTV.isHidden = false
            self.radioButtonView.isHidden = true
        }
        planetsTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredList.count : list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetsTVC", for: indexPath) as! PlanetsTVC
        cell.planetLbl.text = isFiltering ? filteredList[indexPath.row].name : list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlanet = isFiltering ? filteredList[indexPath.row] : list[indexPath.row]
        self.planetsSearchBar.text = isFiltering ? filteredList[indexPath.row].name : list[indexPath.row].name
        self.planetsTV.isHidden = true
        self.radioButtonView.isHidden =  false
        guard let planet = selectedPlanet, let vehicle = selectedVehicle else {return}
        delegate.getPlanetAndVehicle(selectedPlanet: planet, selectedVehicle: vehicle, index: self.index)
    }
}











