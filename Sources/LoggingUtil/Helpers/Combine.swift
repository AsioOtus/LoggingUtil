func combine <T> (_ a: T?, _ b: T?, _ combining: (T, T) -> T) -> T? {
	switch (a, b) {
	case (let .some(a), let .some(b)): return combining(a, b)
	case (let .some(a), nil): return a
	case (nil, let .some(b)): return b
	case (nil, nil): return nil
	}
}
