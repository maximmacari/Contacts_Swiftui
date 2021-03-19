//
//  Home.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var jsonService: JSONService
    
    //Search text
    @State var searchQuery = ""
    
    // Offsets
    @State var offset: CGFloat = 0
    
    //Start offset
    @State var startOffset: CGFloat = 0
    
    //to move title to centere we are getting the title width
    @State var titleOffset: CGFloat = 0
    
    //to get the scrollview padded from the top we are going to get the height of the title bar
    @State var titleBarHeight: CGFloat = 0
    
    //to addapt for dark mode
    @Environment(\.colorScheme) var scheme
    
    
    var body: some View {
        ZStack(alignment: .top){
            //moving the seearch bar to the top if user starts searching
            
            VStack {
                if searchQuery == "" {
                    HStack{
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "star")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.primary)
                        })
                    }
                    .padding()
                    
                    HStack{
                        (
                            Text("My")
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                
                                +
                                
                                Text("friends")
                                .foregroundColor(.gray)
                        )
                        .font(.largeTitle)
                        .overlay(
                            GeometryReader { geo -> Color in
                                let width = geo.frame(in: .global).maxX
                                
                                DispatchQueue.main.async {
                                    //storing
                                    if titleOffset == 0 {
                                        titleOffset = width
                                    }
                                }
                                return Color.clear
                            }
                            .frame(width: 0, height: 0)
                        )
                        .padding()
                        //getting offset and moving the view
                        //scaling...
                        .scaleEffect(getScale())
                        .offset(getOffset())
                        
                        Spacer()
                    }
                    .padding()
                }
                
                VStack{
                    //Searchbar
                    HStack(spacing: 15){
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchQuery)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(8)
                    .padding()
                    
                    if searchQuery == "" {
                        //Divider
                        HStack{
                            Text("Recents")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(height: 0.5)
                        }
                        .padding(.horizontal)
                    }
                }
                .offset(y: offset > 0 && searchQuery == "" ? (offset <= 95 ? -offset : -95) : 0)
                
                
            }
            .zIndex(1)
            //padding bottom, decrease heeight fo the view
            .padding(.bottom,searchQuery == "" ? getOffset().height : 0)
            .background(
                ZStack{
                    let color = scheme == .dark ? Color.black : Color.white
                    
                    LinearGradient(gradient: .init(colors: [color,color,color,color, color.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
            )
            .overlay(
                GeometryReader { geo -> Color in
                    let height = geo.frame(in: .global).maxY
                    DispatchQueue.main.async {
                        if titleBarHeight == 0{
                            titleBarHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                        }
                        
                    }
                    return Color.clear
                }
            )
            //animating only if user starts typing...
            .animation(.easeInOut, value: searchQuery != "")
            
            if jsonService.friends.isEmpty{
                VStack{
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
            }else{
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 15){
                        ForEach(searchQuery == "" ? jsonService.friends : jsonService.friends.filter{
                            $0.friend.firstName.lowercased().contains(searchQuery.lowercased())
                        }
                        ){ data in
                            FriendRowView(data: data)
                        }
                    }
                    .padding(.top, 10)
                    .padding(.top,searchQuery == "" ?  titleBarHeight : 90)
                    //getting offset with geomeetryreader
                    .overlay(
                        GeometryReader{ geo -> Color in
                            let minY = geo.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                //to get original offset
                                if startOffset == 0 {
                                    startOffset = minY
                                }
                                
                                offset = startOffset - minY
                                print(offset)
                            }
                            return Color.clear
                        }
                        .frame(width: 0, height: 0),
                        alignment: .top
                    )
                    
                })
            }
        }
        .onAppear(){
            jsonService.parseJSON()
        }
    }
    
    func getOffset() -> CGSize{
        var size: CGSize = .zero
        
        let screenWidth = UIScreen.main.bounds.width / 2
        
        size.width = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
        size.height = offset > 0 ? (offset <= 75 ? -offset : -75) : 0
        return size
    }
    
    //shrinking when scrolling
    func getScale() -> CGFloat {
        if offset > 0 {
            let screenWidth = UIScreen.main.bounds.width
            let progress = 1 - (getOffset().width / screenWidth)
            return progress >= 0.9 ? progress : 0.9
        }else{
            return 1
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
