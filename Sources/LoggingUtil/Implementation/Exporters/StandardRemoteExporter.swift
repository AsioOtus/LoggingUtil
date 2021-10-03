import Foundation

public class StandardRemoteExporter: CustomizableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	public var url: URL
	public var urlSession = URLSession.shared
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		url: URL,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
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

public extension StandardRemoteExporter {
	@discardableResult
	func url (_ url: URL) -> Self {
		self.url = url
		return self
	}
	
	@discardableResult
	func urlSession (_ urlSession: URLSession) -> Self {
		self.urlSession = urlSession
		return self
	}
}
