import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Member blocks (no qmember needed)

@resultBuilder
public struct qmembers {
  
  // collect
  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [MemberBlockItemSyntax]...) -> [MemberBlockItemSyntax] {
    parts.flatMap { $0 }
  }

  // wrap decls / stmts / exprs
  @inlinable @inline(__always)
  public static func buildExpression(_ d: some DeclSyntaxProtocol) -> [MemberBlockItemSyntax] {
    [MemberBlockItemSyntax(decl: d)]
  }

  // convenience: accept concrete decls without forcing callers to wrap in DeclSyntax
  @inlinable @inline(__always)
  public static func buildExpression(_ d: StructDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: ClassDeclSyntax)  -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: EnumDeclSyntax)   -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: FunctionDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: InitializerDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: VariableDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: TypeAliasDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  @inlinable @inline(__always)
  public static func buildExpression(_ d: EnumCaseDeclSyntax) -> [MemberBlockItemSyntax] { buildExpression(DeclSyntax(d)) }

  // control flow sugar
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [MemberBlockItemSyntax]?) -> [MemberBlockItemSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [MemberBlockItemSyntax]) -> [MemberBlockItemSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [MemberBlockItemSyntax]) -> [MemberBlockItemSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ components: [[MemberBlockItemSyntax]]) -> [MemberBlockItemSyntax] {
    components.flatMap { $0 }
  }
}


@inlinable @inline(__always)
public func qmemberBlock(@qmembers _ make: () -> [MemberBlockItemSyntax]) -> MemberBlockSyntax {
  MemberBlockSyntax(members: MemberBlockItemListSyntax(make()))
}
