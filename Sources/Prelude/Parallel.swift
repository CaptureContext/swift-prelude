import Dependencies
import Dispatch

public final class Parallel<A> {
  @usableFromInline
  internal let compute: () async -> A

  public init(_ compute: @escaping () async -> A) {
    var computed: A? = nil
    self.compute = withEscapedDependencies { continuation in
      return {
        if let computed = computed {
          return computed
        }
        let result = await continuation.yield { await compute() }
        computed = result
        return result
      }
    }
  }

  @inlinable
  public convenience init(_ compute: @escaping (@escaping (A) -> ()) -> ()) {
    self.init {
      await withUnsafeContinuation { continuation in
        compute { a in
          continuation.resume(returning: a)
        }
      }
    }
  }

  @inlinable
  public func run(_ callback: @escaping (A) -> ()) {
    Task {
      await callback(self.compute())
    }
  }
}

@inlinable
public func parallel<A>(_ io: IO<A>) -> Parallel<A> {
  return .init {
    await io.performAsync()
  }
}

extension Parallel {
  @inlinable
  public var sequential: IO<A> {
    return .init { callback in
      self.run(callback)
    }
  }
}

@inlinable
public func sequential<A>(_ x: Parallel<A>) -> IO<A> {
  return x.sequential
}

// MARK: - Functor

extension Parallel {
  @inlinable
  public func map<B>(_ f: @escaping (A) -> B) -> Parallel<B> {
    return .init {
      self.run($0 <<< f)
    }
  }

  @inlinable
  public static func <¢> <B>(f: @escaping (A) -> B, x: Parallel<A>) -> Parallel<B> {
    return x.map(f)
  }
}

@inlinable
public func map<A, B>(_ f: @escaping (A) -> B) -> (Parallel<A>) -> Parallel<B> {
  return { f <¢> $0 }
}

// MARK: - Apply

extension Parallel {
  @inlinable
  public func apply<B>(_ f: Parallel<(A) -> B>) -> Parallel<B> {
    return .init {
      async let f = f.compute()
      async let x = self.compute()
      return await f(x)
    }
  }

  @inlinable
  public static func <*> <B>(f: Parallel<(A) -> B>, x: Parallel<A>) -> Parallel<B> {
    return x.apply(f)
  }
}

@inlinable
public func apply<A, B>(_ f: Parallel<(A) -> B>) -> (Parallel<A>) -> Parallel<B> {
  return { f <*> $0 }
}

// MARK: - Applicative

@inlinable
public func pure<A>(_ x: A) -> Parallel<A> {
  return parallel <<< pure <| x
}

// MARK: - Traversable

@inlinable
public func traverse<C, A, B>(
  _ f: @escaping (A) -> Parallel<B>
) -> (C) -> Parallel<[B]>
where C: Collection, C.Element == A {
  return { xs in
    guard !xs.isEmpty else { return pure([]) }
    
    return Parallel<[B]> { callback in
      let queue = DispatchQueue(label: "pointfree.parallel.sequence")
      
      var completed = 0
      var results = [B?](repeating: nil, count: Int(xs.count))
      
      for (idx, parallel) in xs.map(f).enumerated() {
        parallel.run { b in
          queue.sync {
            results[idx] = b
            completed += 1
            if completed == xs.count {
              callback(results as! [B])
            }
          }
        }
      }
    }
  }
}

@inlinable
public func sequence<C, A>(_ xs: C) -> Parallel<[A]> where C: Collection, C.Element == Parallel<A> {
  return xs |> traverse(id)
}

// MARK: - Alt

extension Parallel: Alt {
  @inlinable
  public static func <|> (lhs: Parallel, rhs: @autoclosure @escaping () -> Parallel) -> Parallel {
    return .init { f in
      var finished = false
      let callback: (A) -> () = {
        guard !finished else { return }
        finished = true
        f($0)
      }
      lhs.run(callback)
      rhs().run(callback)
    }
  }
}

// MARK: - Semigroup

extension Parallel: Semigroup where A: Semigroup {
  @inlinable
  public static func <> (lhs: Parallel, rhs: Parallel) -> Parallel {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension Parallel: Monoid where A: Monoid {
  @inlinable
  public static var empty: Parallel {
    return pure(A.empty)
  }
}
