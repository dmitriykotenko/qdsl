import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Statement builders

@resultBuilder
public struct qdictionary_elements {

  @inlinable @inline(__always)
  public static func element(_ key: ExprSyntax,
                             _ value: some ExprSyntaxProtocol) -> DictionaryElementSyntax {
    .init(
      key: key,
      colon: .colonToken(trailingTrivia: .space),
      value: value
    )
  }

  // collect: flatten nested arrays coming from subexpressions/branches
  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [DictionaryElementSyntax]...) -> [DictionaryElementSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  @inlinable @inline(__always)
  public static func buildExpression(_ element: DictionaryElementSyntax) -> [DictionaryElementSyntax] {
    [element]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [DictionaryElementSyntax]?) -> [DictionaryElementSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ chunks: [[DictionaryElementSyntax]]) -> [DictionaryElementSyntax] {
    chunks.flatMap { $0 }
  }

  @inlinable @inline(__always)
  public static func buildFinalResult(_ components: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] {
    components.enumerated().map { index, element in
      element
        .with(\.leadingTrivia, .newline)
        .with(\.trailingComma, components.trailingComma(forIndex: index))
        .with(\.trailingTrivia, index == components.count - 1 ? .newline : .space)
    }
  }

  // availability branches
  @inlinable @inline(__always)
  public static func buildLimitedAvailability(_ c: [DictionaryElementSyntax]) -> [DictionaryElementSyntax] { c }
}
