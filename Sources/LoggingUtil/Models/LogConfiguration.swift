protocol LogExporterConfiguration { }

public struct LogConfiguration {
	let stringValue: String
	let keyString: [String: String]
	let keyValue: [String: Any]
	let converters: [String: LogConverter]
	let exporterConfigurations: [String: LogExporterConfiguration]
}
