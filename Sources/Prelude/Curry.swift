public func curry<A, B, C>(
  _ function: @escaping (A, B) -> C) -> (A) -> (B
  ) -> C {
  return { (a: A) -> (B) -> C in
    { (b: B) -> C in
      function(a, b)
    }
  }
}

public func curry<A, B, C, D>(
  _ function: @escaping (A, B, C) -> D
) -> (A) -> (B) -> (C) -> D {
  return { (a: A) -> (B) -> (C) -> D in
    { (b: B) -> (C) -> D in
      { (c: C) -> D in
        function(a, b, c)
      }
    }
  }
}

public func curry<A, B, C, D, E>(
  _ function: @escaping (A, B, C, D) -> E
) -> (A) -> (B) -> (C) -> (D) -> E {
  return { (a: A) -> (B) -> (C) -> (D) -> E in
    { (b: B) -> (C) -> (D) -> E in
      { (c: C) -> (D) -> E in
        { (d: D) -> E in
          function(a, b, c, d)
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F>(
  _ function: @escaping (A, B, C, D, E) -> F
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> F in
    { (b: B) -> (C) -> (D) -> (E) -> F in
      { (c: C) -> (D) -> (E) -> F in
        { (d: D) -> (E) -> F in
          { (e: E) -> F in
            function(a, b, c, d, e)
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G>(
  _ function: @escaping (A, B, C, D, E, F) -> G
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> G in
      { (c: C) -> (D) -> (E) -> (F) -> G in
        { (d: D) -> (E) -> (F) -> G in
          { (e: E) -> (F) -> G in
            { (f: F) -> G in
              function(a, b, c, d, e, f)
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H>(
  _ function: @escaping (A, B, C, D, E, F, G) -> H
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> H in
        { (d: D) -> (E) -> (F) -> (G) -> H in
          { (e: E) -> (F) -> (G) -> H in
            { (f: F) -> (G) -> H in
              { (g: G) -> H in
                function(a, b, c, d, e, f, g)
              }
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H, I>(
  _ function: @escaping (A, B, C, D, E, F, G, H) -> I
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I in
        { (d: D) -> (E) -> (F) -> (G) -> (H) -> I in
          { (e: E) -> (F) -> (G) -> (H) -> I in
            { (f: F) -> (G) -> (H) -> I in
              { (g: G) -> (H) -> I in
                { (h: H) -> I in
                  function(a, b, c, d, e, f, g, h)
                }
              }
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H, I, J>(
  _ function: @escaping (A, B, C, D, E, F, G, H, I) -> J
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
        { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J in
          { (e: E) -> (F) -> (G) -> (H) -> (I) -> J in
            { (f: F) -> (G) -> (H) -> (I) -> J in
              { (g: G) -> (H) -> (I) -> J in
                { (h: H) -> (I) -> J in
                  { (i: I) -> J in
                    function(a, b, c, d, e, f, g, h, i)
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K>(
  _ function: @escaping (A, B, C, D, E, F, G, H, I, J) -> K
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
        { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
          { (e: E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K in
            { (f: F) -> (G) -> (H) -> (I) -> (J) -> K in
              { (g: G) -> (H) -> (I) -> (J) -> K in
                { (h: H) -> (I) -> (J) -> K in
                  { (i: I) -> (J) -> K in
                    { (j: J) -> K in
                      function(a, b, c, d, e, f, g, h, i, j)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L>(
  _ function: @escaping (A, B, C, D, E, F, G, H, I, J, K) -> L
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
        { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
          { (e: E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
            { (f: F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L in
              { (g: G) -> (H) -> (I) -> (J) -> (K) -> L in
                { (h: H) -> (I) -> (J) -> (K) -> L in
                  { (i: I) -> (J) -> (K) -> L in
                    { (j: J) -> (K) -> L in
                      { (k: K) -> L in
                        function(a, b, c, d, e, f, g, h, i, j, k)
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public func curry<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  _ function: @escaping (A, B, C, D, E, F, G, H, I, J, K, L) -> M
) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M {
  return { (a: A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
    { (b: B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
      { (c: C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
        { (d: D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
          { (e: E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
            { (f: F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
              { (g: G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M in
                { (h: H) -> (I) -> (J) -> (K) -> (L) -> M in
                  { (i: I) -> (J) -> (K) -> (L) -> M in
                    { (j: J) -> (K) -> (L) -> M in
                      { (k: K) -> (L) -> M in
                        { (l: L) -> M in
                          function(a, b, c, d, e, f, g, h, i, j, k, l)
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public func uncurry<A, B, C>(
  _ _f: @escaping (A) -> (B) -> C
) -> (A, B) -> C {
  return { a, b in
    _f(a)(b)
  }
}

public func uncurry<A, B, C, D>(
  _ _f: @escaping (A) -> (B) -> (C) -> D
) -> (A, B, C) -> D {
  return { a, b, c in
    _f(a)(b)(c)
  }
}

public func uncurry<A, B, C, D, E>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> E
) -> (A, B, C, D) -> E {
  return { a, b, c, d in
    _f(a)(b)(c)(d)
  }
}

public func uncurry<A, B, C, D, E, F>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> F
) -> (A, B, C, D, E) -> F {
  return { a, b, c, d, e in
    _f(a)(b)(c)(d)(e)
  }
}

public func uncurry<A, B, C, D, E, F, G>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> G
) -> (A, B, C, D, E, F) -> G {
  return { a, b, c, d, e, f in
    _f(a)(b)(c)(d)(e)(f)
  }
}

public func uncurry<A, B, C, D, E, F, G, H>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> H
) -> (A, B, C, D, E, F, G) -> H {
  return { a, b, c, d, e, f, g in
    _f(a)(b)(c)(d)(e)(f)(g)
  }
}

public func uncurry<A, B, C, D, E, F, G, H, I>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> I
) -> (A, B, C, D, E, F, G, H) -> I {
  return { a, b, c, d, e, f, g, h in
    _f(a)(b)(c)(d)(e)(f)(g)(h)
  }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> J
) -> (A, B, C, D, E, F, G, H, I) -> J {
  return { a, b, c, d, e, f, g, h, i in
    _f(a)(b)(c)(d)(e)(f)(g)(h)(i)
  }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> K
) -> (A, B, C, D, E, F, G, H, I, J) -> K {
  return { a, b, c, d, e, f, g, h, i, j in
    _f(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)
  }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> L
) -> (A, B, C, D, E, F, G, H, I, J, K) -> L {
  return { a, b, c, d, e, f, g, h, i, j, k in
    _f(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)
  }
}

public func uncurry<A, B, C, D, E, F, G, H, I, J, K, L, M>(
  _ _f: @escaping (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (G) -> (H) -> (I) -> (J) -> (K) -> (L) -> M
) -> (A, B, C, D, E, F, G, H, I, J, K, L) -> M {
  return { a, b, c, d, e, f, g, h, i, j, k, l in
    _f(a)(b)(c)(d)(e)(f)(g)(h)(i)(j)(k)(l)
  }
}
