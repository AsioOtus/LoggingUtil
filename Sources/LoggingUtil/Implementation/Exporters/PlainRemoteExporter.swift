import Foundation
import Combine

public class PlainRemoteExporter: Exporter {
	public var url: URL
	public var urlSession = URLSession.shared
	
	public init (
		url: URL
	) {
		self.url = url
	}
	
	public func export (_ record: ExportRecord<Data>) {
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "POST"
		urlRequest.httpBody = record.message
		
		urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
			if let error = error {
				print(error.localizedDescription)
			}
		}.resume()
	}
}

public extension PlainRemoteExporter {
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

extension PlainRemoteExporter: Subscriber {
    public typealias Input = ExportRecord<Data>
    public typealias Failure = Never
    
    public func receive (subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive (_ input: Input) -> Subscribers.Demand {
        export(input)
        return .none
    }
    
    public func receive (completion: Subscribers.Completion<Never>) { }
}

public extension Publisher {
    func plainRemoteExport (url: URL, urlSession: URLSession = .shared) where Output == PlainRemoteExporter.Input, Failure == PlainRemoteExporter.Failure {
		receive(subscriber: PlainRemoteExporter(url: url).urlSession(urlSession))
    }
}

public extension AnyExporter {
	static func plainRemote (url: URL, urlSession: URLSession = .shared) -> AnyExporter<PlainRemoteExporter.Message> {
		PlainRemoteExporter(url: url).urlSession(urlSession).eraseToAnyExporter()
	}
}
