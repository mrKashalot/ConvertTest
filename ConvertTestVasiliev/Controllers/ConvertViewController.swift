//
//  ViewController.swift
//  ConvertTestVasiliev
//
//  Created by Владислав on 30.03.2021.
//

import UIKit

class ConvertViewController: UIViewController {
    
    //MARK: переменные для захвата значений из полей ввода
    var fromTextField: Double = 0
    var toTextField: Double = 0
    
    private var convertData: ConvertCurrensy?
    
    @IBOutlet weak var fromCurrencyChange: CustomButton!
    @IBOutlet weak var inCurrencyChange: CustomButton!
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var inCurrencyTextField: UITextField!
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
                
                self.convertData = try JSONDecoder().decode(ConvertCurrensy.self, from: data)
                
                //MARK: количество валюты "ИЗ"
                print(self.convertData?.amount)
                self.convertData?.amount = String(self.fromTextField)
                
                //MARK: аббр. валюты "ИЗ"
                print(self.convertData?.baseCurrencyCode)
                
                //MARK: ["RUB": Rates(currency_name: "Russian ruble"), rate: "57.6457", rate_for_amount: "57.6457"]
                print(self.convertData?.rates)
                
            } catch let error {
                
                print("Error serialization", error)
            }
        }.resume()
    }
    
    @IBAction func convertButtonPress(_ sender: UITextField) {
        
        //MARK: проверка условия поля ввода из какой валюты (предварительный варинат проверки и подстановки
        if fromCurrencyTextField.text?.isEmpty == false  {
            
            fromTextField = Double(fromCurrencyTextField.text!)!
            print(fromTextField)
            
            fetchConvertData()
            inCurrencyTextField.text = "результат работы  API"
            
        } else if inCurrencyTextField.text?.isEmpty == false {
            
            toTextField = Double(inCurrencyTextField.text!)!
            print(toTextField)
            
            fetchConvertData()
            fromCurrencyTextField.text = "результат работы  API"
        } else {
            
            warningLabel.isHidden = false
        }
        
    }
    @IBAction func fromCurrencyButtonPress(_ unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func toCurrencyButtonPress(_ unwindSegue: UIStoryboardSegue) {
    }
}


//MARK: - делегат расширения класса поля ввода
extension ConvertViewController: UITextFieldDelegate {
    func textFieldReturn(_ textFiled: UITextField) -> Bool {
        
        textFiled.resignFirstResponder()
        
        return true
    }
    
    //MARK: Функция скрытия клавиатуры при нажатии кнопки 'Enter'
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
            convertButton.isEnabled = true
            convertButton.backgroundColor = .green
            convertButton.alpha = 1
            
        } else if fromCurrencyTextField.text?.isEmpty == false {
            inCurrencyTextField.text = nil
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

