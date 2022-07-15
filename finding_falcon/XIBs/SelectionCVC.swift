//
//  SelectionCVC.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import UIKit

class SelectionCVC: UICollectionViewCell ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    
//MARK: - Outlets
    
    @IBOutlet weak var radioButtonView: UIView!
    @IBOutlet weak var planetsTV: UITableView!
    @IBOutlet weak var planetsSearchBar: UISearchBar!
    @IBOutlet weak var radioButton1: RadioButton!
    @IBOutlet weak var radioButton2: RadioButton!
    @IBOutlet weak var radioButton3: RadioButton!
    @IBOutlet weak var radioButton4: RadioButton!
    
    //MARK: - Local Variables
    var list = Planets()
    var filteredList = [Planet]()
    var isFiltering = Bool()
    var vehicleList = Vehicles()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.planetsSearchBar.delegate = self
    }
    
    func initRadioButtons() {
        let radioButtons = [radioButton1,radioButton2,radioButton3,radioButton4]
        radioButtons.enumerated().forEach({ idx,radioButton in
            radioButton?.isSelected = false
            radioButton?.titleLabel?.text = vehicleList[idx].name
            radioButton?.alternateButton = radioButtons.filter({ alternateButton in
                return radioButton == alternateButton ? false : true
            })
        })
        radioButtons[0]?.isSelected = true
        }
    
    
    
    func configureCell(planets : Planets, vehicles : Vehicles) {
        list = planets
        vehicleList = vehicles
        initRadioButtons()
        self.planetsTV.isHidden = true
        self.planetsTV.delegate = self
        self.planetsTV.dataSource = self
        self.planetsTV.register(UINib(nibName: "PlanetsTVC", bundle: nil), forCellReuseIdentifier: "PlanetsTVC")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Search for: ",searchText)
            self.planetsTV(searchText)
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
    

    }

class RadioButton: UIButton {
    var alternateButton: [RadioButton?]?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.masksToBounds = true
    }
    
    func unselectAlternateButtons() {
        if alternateButton != nil {
            self.isSelected = true
            
            for aButton:RadioButton? in alternateButton! {
                aButton?.isSelected = false
            }
        } else {
            toggleButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton() {
        self.isSelected = !isSelected
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.borderColor = UIColor.cyan.cgColor
            } else {
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
}











