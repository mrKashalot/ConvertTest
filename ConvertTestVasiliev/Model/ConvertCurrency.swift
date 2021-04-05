//
//  ConvertTest.swift
//  ConvertTestVasiliev
//
//  Created by Владислав on 03.04.2021.
//

import Foundation

struct ConvertCurrensy: Codable {
    var baseCurrencyCode: String
    let baseCurrencyName: String
    var amount: String
    let updatedDate: String
    var rates: [String: Rates]?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case status,amount,rates
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
        case updatedDate = "updated_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseCurrencyCode = try container.decode(String.self, forKey: .baseCurrencyCode)
        baseCurrencyName = try container.decode(String.self, forKey: .baseCurrencyName)
        updatedDate = try container.decode(String.self, forKey: .updatedDate)
        status = try container.decode(String.self, forKey: .status)
        amount = try container.decode(String.self, forKey: .amount)
        rates = try? container.decode([String: Rates].self, forKey: .rates)
    }
}

struct Rates: Codable {
    var currency_name: String?
    var rate: String?
    var rate_for_amount: String?
}


