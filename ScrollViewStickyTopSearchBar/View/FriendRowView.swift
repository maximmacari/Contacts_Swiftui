//
//  FriendRowView.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI

struct FriendRowView: View {
    
    var data: FriendVM
    
    var body: some View {
        HStack(spacing: 15){
            
            AsyncImage(imageUrl: data.friend.image)
                
            
            VStack(alignment: .leading, spacing: 8, content: {
                Text(data.friend.firstName)
                    .fontWeight(.bold)
                
                Text(data.distanceDetail)
                    .font(.caption)
                    .foregroundColor(.gray)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                
            }, label: {
                Image(systemName: "message.fill")
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
            })
            .padding(.trailing, -5)
            
            Button(action: {
                
            }, label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(Color.yellow.opacity(0.9))
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .clipShape(Circle())
            })
        }
        .padding(.horizontal)
    }
    
    struct AsyncImage: View {
        
        @StateObject private var loader: ImageLoader
        
        
        init(imageUrl: String) {
            _loader = StateObject(wrappedValue: ImageLoader(imageURL: imageUrl))
        }
        
        var body: some View {
            Group{
                VStack{
                    if(loader.image != nil), let uiImage = loader.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    } else {
                        ProgressView()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                    }
                }
            }
            .onAppear(){
                loader.load()
            }
        }
        
    }
}

struct FriendRowView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
