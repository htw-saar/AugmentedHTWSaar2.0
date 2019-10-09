//
//  HMAC.swift
//  AugmentedHTWSaarEsch
//
//  Created by Christopher Jung on 15.07.19.
//  Copyright © 2019 AugmentedReality. All rights reserved.
//

import Foundation
import CommonCrypto
import Alamofire

extension HMAC {
    enum Algorithm {
        case sha1
        case sha256
        case sha512
        
        var digestLength: Int {
            switch self {
                case .sha1: return Int(CC_SHA1_DIGEST_LENGTH)
                case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
                case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }
        
        var rawValue: Int {
            switch self {
                case .sha1: return kCCHmacAlgSHA1
                case .sha256: return kCCHmacAlgSHA256
                case .sha512: return kCCHmacAlgSHA512
            }
        }
        
        var name: String {
            switch self {
                case .sha1: return "HmacSHA1"
                case .sha256: return "HmacSHA256"
                case .sha512: return "HmacSHA512"
            }
        }
    }
}

class HMAC {
    
    class func randomString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    class func jsonRequest(url : String) -> URLRequest {
        let user = User.current

        let authorization = authenticationCode( url: url,apiUser: user.apiUser!,apiSecret: user.apiSecret!)
        
        var urlRequest = URLRequest(url: URL(string: "\(Config.url)\(url)")!)
        
        var test = URL(string: "\(Config.url)\(url)")!
        
        urlRequest.setValue(authorization, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
    
    class func authenticationCode( for algorithm: Algorithm = .sha512, url: String, apiUser: String, apiSecret: String) -> String {
        let nonce = randomString(64)
        let time = "\(UInt64(round(Date().timeIntervalSince1970)))"
        let signature = "\(url.split {$0 == "?"} [0])\(apiUser)\(nonce)\(time)"
        
        guard let secretKeyData = apiSecret.data(using: .utf8) else { fatalError() }
        guard let signatureData = signature.data(using: .utf8) else { fatalError() }
        let digest = calculateDigest(for: algorithm, secretKey: secretKeyData, data: signatureData)
        
        return "\(algorithm.name):\(apiUser):\(nonce):\(time):\(digest)"
    }
    
    class func calculateDigest( for algorithm: Algorithm, secretKey: Data, data: Data) -> String {
        let hashBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: algorithm.digestLength)
        defer { hashBytes.deallocate() }
        data.withUnsafeBytes { (bytes) -> Void in
            secretKey.withUnsafeBytes { (secretKeyBytes) -> Void in
                CCHmac(CCHmacAlgorithm(algorithm.rawValue), secretKeyBytes, secretKey.count, bytes, data.count, hashBytes)
            }
        }
        
        let data = Data(bytes: hashBytes, count: algorithm.digestLength)
        
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
}


extension DataRequest{
    func responseObject<T>(_ type: T.Type) -> T? where T : Decodable{
        let response = responseData();
        let decoder = JSONDecoder()
        let str = String(data: response.data!, encoding: .utf8)
        
        
        
        print("JSON from server: \(self.request?.mainDocumentURL?.absoluteString) result: \(str)")
        
        do {
            return try decoder.decode(type, from: response.data!)
        } catch  {
            print("Unexpected error: \(error).")
        }
        
        return nil
    }
}
