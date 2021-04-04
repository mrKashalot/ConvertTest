//
//  CurrencyListViewController.swift
//  ConvertTestVasiliev
//
//  Created by Владислав on 31.03.2021.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    var currencyArray = [String?]()
    
    //MARK: объявляем перtменную класса для использования индикатора загрузки
    let activityIndicator = ActivityIndicator()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        //MARK: запускаем метод
        fetchCurrencyData()
    }
    
    //MARK: - подгрузки данных наименования валюты
    func fetchCurrencyData() {
        
        let headers = [
            "x-rapidapi-key": "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5",
            "x-rapidapi-host": "currency-converter5.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://currency-converter5.p.rapidapi.com/currency/list?apiKey=f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5&format=json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        self.view.addSubview(activityIndicator)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let data = data else { return }
                
                do {
                    
                    let allCurrency = try JSONDecoder().decode(DataCurrencyName.self, from: data)
                    
                    self.currencyArray = Mirror(reflecting: allCurrency).children.map { $0.label! }
                    
                    //MARK: оставил тут для проверки вывода необходимого массива
                    print(self.currencyArray)
                    
                    self.tableView.reloadData()
                    self.activityIndicator.hide()
                    
                } catch let error {
                    
                    print("Error serialization", error)
                    
                }
            }
        }.resume()
    }
}

extension CurrencyListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CurrencyCell
        
        cell.currencyNameLabel.text = currencyArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        navigationController?.popViewController(animated: true)
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}


