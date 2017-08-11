//
//  ViewController_KeyChain.swift
//  SwiftDemoKit
//
//  Created by runo on 17/8/8.
//  Copyright © 2017年 com.runo. All rights reserved.
//

import UIKit
import Security

class ViewController_KeyChain: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         //方法一：
         NSError *error;
         NSURL *ipURL = [NSURL URLWithString:@"http://ifconfig.me/ip"];
         NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
         //方法二：个人推荐用这个请求，速度比较快
         /*
         http://ipof.in/json
         http://ipof.in/xml
         http://ipof.in/txt
         If you want HTTPS you can use the same URLs with https prefix. The advantage being that even if you are on a Wifi you will get the public address.
         */
         NSError *error;
         NSURL *ipURL = [NSURL URLWithString:@"http://ipof.in/txt"];
         NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
         */
        
        let url = URL.init(string: "http://ifconfig.me/ip")
        do {
            let ipaddress = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            print("ip \(ipaddress)")
        }
        catch{
            print(error)
        }
    }

}



struct KeychainConfiguration {
    
    static let serviceName = "MyAppService"
    static let accessGroup: String? = nil
    
}

struct KeychainPasswordItem {
    
    enum KeychainError: Error {
        case noPassword //这个item没在keychain存密码
        case unexpectedPasswordData //解析密码错误
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    let service: String
    private(set) var account: String
    let accessGroup: String?
    
    init(service: String, account: String, accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    func readPassword() throws -> String {
        
        var query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(mutating: $0))
        }
        
        //表示根本就没有这个账号存储过
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        //有错误，抛出错误
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String.init(data: passwordData, encoding: String.Encoding.utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }
        return password
    }
    
    //保存密码，区分是修改还是添加新的
    func savePassword(_ password: String) throws {
        
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do{
            try _ = readPassword()//首先读取一下，判断是更新密码还是添加密码
            //可以读取代表是更新密码
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            //有错误抛出错误
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        
        }catch KeychainError.noPassword {
            //表示要新加password
            var newItem = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
    }
    
    //修改账号
    mutating func renameAccount(_ newAccountName: String) throws {
        
        var attributesToUpdate = [String: AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: self.account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        self.account = newAccountName
    }
    
    //删除item
    func deleteItem() throws {
        
        let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainPasswordItem] {
        
        var query = KeychainPasswordItem.keychainQuery(withService: service, accessGroup: accessGroup)
        
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse
        
        var queryResult: AnyObject?
        let status = withUnsafePointer(to: &queryResult) { (par) -> OSStatus in
           return SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(mutating: par))
        }
        //无匹配数据
        guard status != errSecItemNotFound else {
            return []
        }
        
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        //数据类型不对
        guard let resultData = queryResult as? [[String : AnyObject]] else {
            throw KeychainError.unexpectedItemData
        }
        
        var passwordItems = [KeychainPasswordItem]()
        for result in resultData {
            guard let account = result[kSecAttrAccount as String] as? String else {
                throw KeychainError.unexpectedItemData
            }
            let passwordItem = KeychainPasswordItem.init(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        return passwordItems
    }
    
    //组建查询字典
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
    
}



















