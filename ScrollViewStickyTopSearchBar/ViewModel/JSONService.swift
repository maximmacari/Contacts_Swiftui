//
//  JSONService.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI

class JSONService: ObservableObject {
    
    
    @Published var friends = [FriendVM]()
    
    func parseJSON(){
        do {
            if let localData = self.readFile() {
                let decodedData = try JSONDecoder().decode([Friend].self, from: localData)
                DispatchQueue.main.async {
                    self.friends = decodedData.map({ FriendVM(friend: $0)})
                }
                for friend in friends {
                    print("\(friend.friend.firstName)")
                    print("     deetail: \(friend.distanceDetail)")
                    print("     img: \(friend.friend.image)")
                }
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    private func readFile() -> Data? {
        do{
            if let bundlePath = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json"){
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
                return jsonData
            }
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
}


