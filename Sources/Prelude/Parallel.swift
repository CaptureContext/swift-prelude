import Dependencies
import Dispatch

public final class Parallel<Output>: AsyncFunction {
  public typealias Input = Void

  @usableFromInline
  internal let compute: () async -> Output

  public init(_ call: @escaping AsyncSignature) {
    var computed: Output? = nil
    self.compute = withEscapedDependencies { continuation in
      return {
        if let computed = computed {
          return computed
        }
        let result = await continuation.yield { await call(()) }
        computed = result
        return result
      }
    }
  }

  public func callAsFunction(_ input: Void) async -> Output {
    await compute()
  }

  @inlinable
  public func run(
    priority: TaskPriority? = .none,
    _ callback: @escaping (Output) -> Void
  ) {
    Task(priority: priority) {
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
  public var sequential: IO<Output> {
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
  public func map<NewOutput>(
    _ f: @escaping (Output) -> NewOutput
  ) -> Parallel<NewOutput> {
    return .init(unsafe: { _ in
      return { handler in
        self.run(handler <<< f)
      }
    })
  }

  @inlinable
  public static func <¢> <NewOutput>(
    lhs: @escaping (Output) -> NewOutput,
    rhs: Parallel<Output>
  ) -> Parallel<NewOutput> {
    return rhs.map(lhs)
  }
}

@inlinable
public func map<A, B>(_ f: @escaping (A) -> B) -> (Parallel<A>) -> Parallel<B> {
  return { f <¢> $0 }
}

// MARK: - Apply

extension Parallel {
  @inlinable
  public func apply<NewOutput>(
    _ f: Parallel<(Output) -> NewOutput>
  ) -> Parallel<NewOutput> {
    return .init {
      async let f = f.compute()
      async let x = self.compute()
      return await f(x)
    }
  }

  @inlinable
  public static func <*> <NewOutput>(
    lhs: Parallel<(Output) -> NewOutput>,
    rhs: Parallel<Output>
  ) -> Parallel<NewOutput> {
    return rhs.apply(lhs)
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

    return Parallel<[B]>(unsafe: { callback in
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
    })
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
    return .init(unsafe: { f in
      var finished = false
      let callback: (Output) -> () = {
        guard !finished else { return }
        finished = true
        f($0)
      }
      lhs.run(callback)
      rhs().run(callback)
    })
  }
}

// MARK: - Semigroup

extension Parallel: Semigroup where Output: Semigroup {
  @inlinable
  public static func <> (lhs: Parallel, rhs: Parallel) -> Parallel {
    return curry(<>) <¢> lhs <*> rhs
  }
}

// MARK: - Monoid

extension Parallel: Monoid where Output: Monoid {
  @inlinable
  public static var empty: Parallel {
    return pure(Output.empty)
  }
}
