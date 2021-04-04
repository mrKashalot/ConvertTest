//
//  ViewController.swift
//  ConvertTestVasiliev
//
//  Created by Владислав on 30.03.2021.
//

import UIKit

protocol ViewController: class {
    func update(text: String)
}

class ViewController: UIViewController, ViewController {
    
    var currencyFrom = "USD"
    var currencyTo = "RUB"
    var amountValue = "2"
    
    @IBOutlet weak var fromCurrencyChange: CustomButton!
    @IBOutlet weak var inCurrencyChange: CustomButton!
    @IBOutlet weak var inCurrencyTextField: UITextField!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var convertButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: состояние кнопки в момент загрузки контроллера
        warningLabel.isHidden = true
        convertButton.isEnabled = false
        convertButton.backgroundColor = .gray
        convertButton.alpha = 0.5
        
        //MARK: обработка нажатия на поле ввода для отображения состояния кнопки конвертации
        inCurrencyTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        fromCurrencyTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        inCurrencyTextField.delegate = self
        fromCurrencyTextField.delegate = self
    }
    
    //MARK: - подгрузки данных по нажатию кнопки конвертации
    func fetchConvertData() {
        
        let headers = [
            "x-rapidapi-key": "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5",
            "x-rapidapi-host": "currency-converter5.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://currency-converter5.p.rapidapi.com/currency/convert?from=AUD&to=RUB&amount=1&apiKey=f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5&format=json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                let convertData = try JSONDecoder().decode(ConvertCurrensy.self, from: data)
                
                print(convertData)
                
            } catch let error {
                
                print("Error serialization", error)
            }
        }.resume()
    }
    
    @IBAction func convertButtonPress(_ sender: UIButton) {
        
        fetchConvertData()
    }
    
    @IBAction func fromCurrencyButtonPress(_ unwindSegue: UIStoryboardSegue) {
    }
    
    @IBAction func toCurrencyButtonPress(_ sender: Any) {
        
    }
}


//MARK: - делегат расширения класса поля ввода
extension ViewController: UITextFieldDelegate {
    func textFieldReturn(_ textFiled: UITextField) -> Bool {
        
        textFiled.resignFirstResponder()
        
        return true
    }
    
    // Функция убирания клавиатуры при нажатии кнопки 'Enter'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inCurrencyTextField.resignFirstResponder()
        fromCurrencyTextField.resignFirstResponder()
        return true
    }
    
    //MARK: метод не дает вводить в текстовые поля ничего кроме чисел и точки
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringValue = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        
        guard !stringValue.isEmpty else { return true }
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .none
        
        return numberFormatter.number(from: stringValue)?.intValue != nil
    }
    
    //MARK: состояние кнопки и полей в зависимости от действий
    @objc private func textFieldChanged() {
        
        if inCurrencyTextField.text?.isEmpty == false {
            fromCurrencyTextField.text = nil
            fromCurrencyTextField.text = ""
            convertButton.isEnabled = true
            convertButton.backgroundColor = .green
            convertButton.alpha = 1
            
        } else if fromCurrencyTextField.text?.isEmpty == false {
            inCurrencyTextField.text = nil
            inCurrencyTextField.text = ""
            convertButton.isEnabled = true
            convertButton.backgroundColor = .green
            convertButton.alpha = 1
            
        } else {
            convertButton.isEnabled = false
            convertButton.backgroundColor = .gray
            convertButton.alpha = 0.5
        }
    }
}

