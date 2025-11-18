import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - 'private', 'open', 'static', 'indirect' and other modifiers

public enum m {

  public static let `private` = fromKeyword(.private)
  public static let `fileprivate` = fromKeyword(.fileprivate)
  public static let `public` = fromKeyword(.public)
  public static let `open` = fromKeyword(.open)

  public static let `static` = fromKeyword(.static)
  public static let `indirect` = fromKeyword(.indirect)
  public static let `override` = fromKeyword(.override)

  @inlinable public static func fromKeyword(_ keyword: Keyword) -> DeclModifierSyntax {
    .init(name: q.tok.keyword(keyword))
  }
}
