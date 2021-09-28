import Foundation

public class StandardRemoteExporter: ConfigurableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	public var url: URL
	public var urlSession = URLSession.shared
	
	public init (url: URL) {
		self.url = url
	}
	
	public func export (metaInfo: MetaInfo, message: Data) {
		guard isEnabled, metaInfo.level >= level else { return }
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = message
		
		urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
			if let error = error {
				print(error.localizedDescription)
			}
		}.resume()
	}
}

extension StandardRemoteExporter {
	@discardableResult
	public func url (_ url: URL) -> Self {
		self.url = url
		return self
	}
	
	@discardableResult
	public func urlSession (_ urlSession: URLSession) -> Self {
		self.urlSession = urlSession
		return self
	}
}
