import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Inheritance (optional)

@resultBuilder
public struct qdeclGroup {

  // collect: flatten nested arrays coming from subexpressions/branches
  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [DeclSyntax]...) -> [DeclSyntax] {
    parts.flatMap { $0 }
  }

  @inlinable @inline(__always)
  public static func buildExpression<D: DeclSyntaxProtocol>(_ d: D) -> [DeclSyntax] {
    [DeclSyntax(d)]
  }

  @inlinable @inline(__always)
  public static func buildExpression<D: DeclSyntaxProtocol>(_ d: D?) -> [DeclSyntax] {
    d.map { DeclSyntax($0) }.map { [$0] } ?? []
  }

  @inlinable @inline(__always)
  public static func buildExpression(_ group: [DeclSyntax]) -> [DeclSyntax] {
    group
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [DeclSyntax]?) -> [DeclSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [DeclSyntax]) -> [DeclSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [DeclSyntax]) -> [DeclSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ chunks: [[DeclSyntax]]) -> [DeclSyntax] {
    chunks.flatMap { $0 }
  }

  // availability branches
  @inlinable @inline(__always)
  public static func buildLimitedAvailability(_ c: [DeclSyntax]) -> [DeclSyntax] { c }
}


@inlinable @inline(__always)
public func _members(@qdeclGroup _ makeMembers: () -> [DeclSyntax]) -> [DeclSyntax] {
  makeMembers()
}
