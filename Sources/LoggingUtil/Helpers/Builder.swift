@resultBuilder
public struct ArrayBuilder {
	public static func buildBlock <T> (_ components: T...) -> [T] {
		components
	}
}
