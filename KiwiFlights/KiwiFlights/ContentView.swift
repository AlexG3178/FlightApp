//
//  ContentView.swift
//  KiwiFlights
//
//  Created by Alexandr Grigoriev on 20.08.2022.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                loadingSection
            }
            else
            {
                if viewModel.response.count < 1 {
                    emptyResponseSection
                }
                else
                {
                    titleSection
                    
                    TabView {
                        ForEach(viewModel.response, id: \.id) { item in
                            
                            VStack(spacing: 40, content: {
                                
                                imageSeciton(item)
                                
                                generalDataSection(item: item, viewModel: viewModel)
                                
                                contentSection(item)
                            })
                        }
                    }
                    .ignoresSafeArea()
                    .tabViewStyle(.page)
                }
            }
        }
//                .onAppear {
//                    Task {
//                        await viewModel.loadData()
//                    }
//                }
        
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            AppDelegate.orientationLock = .all
        }
        .background(Color("backgroundColor"))
    }
}

private var loadingSection: some View {
    ZStack {
        Color(.systemBackground)
            .ignoresSafeArea()
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .green))
            .scaleEffect(4)
    }
}

private var emptyResponseSection: some View {
    
    VStack(spacing: 20) {
        Image(systemName: "airplane.arrival")
            .resizable()
            .frame(width: 100, height: 100)
            .scaledToFit()
        
        Text("There are no flights right now.\n Please try again later.")
            .multilineTextAlignment(.center)
    }
    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
}

private var titleSection: some View {
    Text("Flight offers")
        .foregroundColor(Constants.textColor)
        .font(.system(size: Constants.textTitleSize))
}

struct imageSeciton: View {
    
    private var item: FlightData
    
    init(_ item: FlightData) {
        self.item = item
    }
    
    var body: some View {
        AsyncImage(url: URL(string: "https://images.kiwi.com/photos/600x600/\(item.cityTo.lowercased())_\(item.countryTo.code.lowercased()).jpg"), content: { image in
            image.resizable()
        }, placeholder: {
            Image("defaultImage")
                .resizable()
        } )
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        .scaledToFit()
    }
}

struct generalDataSection: View {
    
    private var item: FlightData
    private var viewModel: ViewModel
    
    init(item: FlightData, viewModel: ViewModel) {
        self.item = item
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text(item.countryTo.name.uppercased())
                .font(.system(size: Constants.textSubTitleSize))
                .foregroundColor(Constants.textColor)
            
            Spacer(minLength: Constants.customPadding)
            
            Text("from \(item.price) \(viewModel.currency)")
                .font(.system(size: Constants.textSubTitleSize))
                .foregroundColor(Constants.textColor)
        }
        .padding(.horizontal, Constants.customPadding)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct contentSection: View {
    
    private var item: FlightData
    
    init(_ item: FlightData) {
        self.item = item
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let route = item.route.first {
                    Text("Fly date: \(Helper.formatIsoDate(route.local_departure))")
                        .font(.system(size: Constants.textSubTitleSize))
                        .foregroundColor(Constants.textColor)
                } else {
                    Text("Fly date: --/--/--")
                        .font(.system(size: Constants.textSubTitleSize))
                        .foregroundColor(Constants.textColor)
                }
                
                Text("City from: \(item.cityFrom)")
                    .font(.system(size: Constants.textSubTitleSize))
                    .foregroundColor(Constants.textColor)
                
                Text("City to: \(item.cityTo)")
                    .font(.system(size: Constants.textSubTitleSize))
                    .foregroundColor(Constants.textColor)
                
                buttonSection
            }
        }
    }
}

var buttonSection: some View {
    Button(action: {
        
    }, label: {
        Text("Book now".uppercased())
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(10)
            .background(
                Color("buttonColor")
                    .cornerRadius(10)
            )
    })
    .padding()
}



//struct ContentView: View {
//
//    @StateObject var viewModel = ViewModel()
//
//    let textColor = Color("textColor")
//    let textTitleSize: CGFloat = 24
//    let textSubTitleSize: CGFloat = 20
//    let textNormalSize: CGFloat = 14
//    let padding: CGFloat = 30
//    let title: String = "Flight offers"
//
//    var body: some View {
//
//        VStack {
//            if viewModel.isLoading {
//                ZStack {
//                    Color(.systemBackground)
//                        .ignoresSafeArea()
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
//                        .scaleEffect(4)
//                }
//            }
//            else
//            {
//                if viewModel.response.count < 1 {
//                    VStack(spacing: 20) {
//                        Image(systemName: "airplane.arrival")
//                            .resizable()
//                            .frame(width: 100, height: 100)
//                            .scaledToFit()
//
//                        Text("There are no flights right now.\n Please try again later.")
//                            .multilineTextAlignment(.center)
//                    }
//                }
//                else
//                {
//                    Text(title)
//                        .foregroundColor(textColor)
//                        .font(.system(size: textTitleSize))
//
//                    TabView {
//                        ForEach(viewModel.response, id: \.id) { item in
//
//                            GeometryReader { geo in
//
//                                VStack(spacing: 40, content: {
//                                    AsyncImage(url: URL(string: "https://images.kiwi.com/photos/600x600/\(item.cityTo.lowercased())_\(item.countryTo.code.lowercased()).jpg"), content: { image in
//                                        image.resizable()
//                                    }, placeholder: {
//                                        Image("defaultImage")
//                                            .resizable()
//                                    } )
//                                        .frame(width: geo.size.width, height: geo.size.width)
//                                        .scaledToFit()
//
//                                    HStack {
//                                        Text(item.countryTo.name.uppercased())
//                                            .font(.system(size: textSubTitleSize))
//                                            .foregroundColor(textColor)
//
//                                        Spacer(minLength: padding)
//
//                                        Text("from \(item.price) \(viewModel.currency)")
//                                            .font(.system(size: textSubTitleSize))
//                                            .foregroundColor(textColor)
//                                    }
//                                    .padding(.horizontal, padding)
//                                    .frame(width: geo.size.width)
//
//                                    VStack(spacing: 10) {
//                                        Text("Fly date: \(Date().getDateString())")
//                                            .font(.system(size: textSubTitleSize))
//                                            .foregroundColor(textColor)
//
//                                        Text("City from: \(item.cityFrom)")
//                                            .font(.system(size: textSubTitleSize))
//                                            .foregroundColor(textColor)
//
//                                        Text("City to: \(item.cityTo)")
//                                            .font(.system(size: textSubTitleSize))
//                                            .foregroundColor(textColor)
//
//                                        Button(action: {
//
//                                        }, label: {
//                                            Text("Book now".uppercased())
//                                                .font(.headline)
//                                                .fontWeight(.semibold)
//                                                .foregroundColor(.white)
//                                                .padding(10)
//                                                .background(
//                                                    Color("buttonColor")
//                                                        .cornerRadius(10)
//                                                )
//
//                                        })
//                                        .padding()
//                                    }
//                                })
//                            }
//                        }
//                    }
//                    .ignoresSafeArea()
//                    .tabViewStyle(.page)
//                }
//            }
//        }
//        .onAppear {
//            Task {
//                await viewModel.loadData()
//            }
//        }
//        .background(Color("backgroundColor"))
//    }
//}

