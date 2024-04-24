//
//  ContentView.swift
//  Veil
//
//  Created by Tristan on 4/23/24.
//

import SwiftUI
import WebKit
import AppKit

struct ContentView: View {
    let websites = [
        Website(name: "DuckDuckGo", urlString: "https://www.duckduckgo.com", imageName: "DuckDuckGo"),
        Website(name: "Startpage", urlString: "https://www.startpage.com/", imageName: "Startpage"),
        Website(name: "Youtube", urlString: "https://www.youtube.com", imageName: "Youtube"),
        Website(name: "Discord", urlString: "https://www.discord.com", imageName: "Discord"),
        Website(name: "Netflix", urlString: "https://www.netflix.com", imageName: "Netflix"),
        Website(name: "Twitch", urlString: "https://www.twitch.tv", imageName: "Twitch"),
        Website(name: "Zoom", urlString: "https://www.zoom.us", imageName: "Zoom"),
        Website(name: "Apple", urlString: "https://www.apple.com", imageName: "Apple"),
        Website(name: "Microsoft", urlString: "https://www.microsoft.com", imageName: "Microsoft"),
        Website(name: "Amazon", urlString: "https://www.amazon.com", imageName: "Amazon"),
        Website(name: "Ebay", urlString: "https://www.ebay.com", imageName: "Ebay"),
        Website(name: "Speedometer", urlString: "https://browserbench.org/Speedometer2.1/", imageName: "Speedometer"),
    ]
    
    @State private var clearDataOnClose = true
    
    var body: some View {
        VStack {
            Toggle(isOn: $clearDataOnClose) {
                Text("Clear my data when I close Veil")
            }
            .padding()

            let logoscale = 10;
            Image("Veil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 3840 / CGFloat(logoscale), height: 2160 / CGFloat(logoscale))
                .padding(.bottom)
                .padding(.top)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 5) {
                    ForEach(websites, id: \.self) { website in
                        Button(action: {
                            openURL(website.urlString, title: website.name)
                        }) {
                            VStack {
                                Image(website.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                Text(website.name)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    func openURL(_ urlString: String, title: String) {
        if let url = URL(string: urlString) {
            let webView = createWebViewWithDNT()
            webView.load(URLRequest(url: url))
            
            let hostingController = NSHostingController(rootView: WebView(webView: webView))
            let window = NSWindow(contentViewController: hostingController)
            window.title = "Veil - \(title)"
            window.setFrame(NSRect(x: 0, y: 0, width: 1600, height: 900), display: true)
            window.makeKeyAndOrderFront(nil)
            window.center()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    struct WebView: NSViewRepresentable {
        let webView: WKWebView
        
        func makeNSView(context: Context) -> WKWebView {
            return webView
        }
        
        func updateNSView(_ nsView: WKWebView, context: Context) {
            
        }
    }
    
    struct Website: Hashable {
        let name: String
        let urlString: String
        let imageName: String
    }

    func createWebViewWithDNT() -> WKWebView {
        let configuration = WKWebViewConfiguration()
        print("Sending 'DO NOT TRACK' request...")
        let dntScript = WKUserScript(source: "navigator.doNotTrack = '1';", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(dntScript)
        
        print("Sending 'DO NOT SELL' request...")
        let dnsmpiScript = WKUserScript(source: "navigator.globalPrivacyControl = '1';", injectionTime: .atDocumentStart, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(dnsmpiScript)
        if (clearDataOnClose) {
            print("Stopping cookies...")
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        } else {
            print("Allowing cookies...")
        }
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }
}

struct Tab: Identifiable {
    let id = UUID()
    let url: URL
    let window: NSWindow?
}

class TabManager: ObservableObject {
    @Published var tabs: [Tab] = []
    @Published var activeTabIndex: Int = 0

    func addTab(_ tab: Tab) {
        tabs.append(tab)
        activeTabIndex = tabs.count - 1
    }

    func removeTab(at index: Int) {
        tabs.remove(at: index)
        if activeTabIndex >= tabs.count {
            activeTabIndex = tabs.count - 1
        }
    }

    func getActiveTab() -> Tab? {
        guard activeTabIndex < tabs.count else { return nil }
        return tabs[activeTabIndex]
    }
}
