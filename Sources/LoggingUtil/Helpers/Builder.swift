@resultBuilder
struct ArrayBuilder {
	static func buildBlock <T> (_ components: T...) -> [T] {
		components
	}
}
