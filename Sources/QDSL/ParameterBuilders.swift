import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Parameter builders & short decls

@resultBuilder
public struct qparams {

  @inlinable @inline(__always)
  public static func buildBlock(_ parts: [FunctionParameterSyntax]...) -> [FunctionParameterSyntax] {
    parts.flatMap { $0 }
  }

  // allow expressions as statements
  @inlinable @inline(__always)
  public static func buildExpression(_ e: FunctionParameterSyntax) -> [FunctionParameterSyntax] {
    [e]
  }

  // control-flow sugar so `if`/`guard`/`for` inside builders just work
  @inlinable @inline(__always)
  public static func buildOptional(_ c: [FunctionParameterSyntax]?) -> [FunctionParameterSyntax] { c ?? [] }

  @inlinable @inline(__always)
  public static func buildEither(first c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }

  @inlinable @inline(__always)
  public static func buildEither(second c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }

  @inlinable @inline(__always)
  public static func buildArray(_ chunks: [[FunctionParameterSyntax]]) -> [FunctionParameterSyntax] {
    chunks.flatMap { $0 }
  }

  // availability branches
  @inlinable @inline(__always)
  public static func buildLimitedAvailability(_ c: [FunctionParameterSyntax]) -> [FunctionParameterSyntax] { c }
}


@inlinable @inline(__always)
public func _funcParams(@qparams _ make: () -> [FunctionParameterSyntax]) -> FunctionParameterListSyntax {
  let list = make()

  return FunctionParameterListSyntax(
    list.enumerated().map { index, parameter in
      parameter
        .with(\.trailingComma, list.trailingComma(forIndex: index))
    }
  )
}


extension q {

  /// `name: type` with optional default
  @inlinable @inline(__always)
  public static func funcParam(_ name: String,
                               secondName: String? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
    funcParam(
      q.tok.id(name),
      secondName: secondName.map { q.tok.id($0) },
      type,
      default: def
    )
  }

  /// `name: type` with optional default
  @inlinable @inline(__always)
  public static func funcParam(_ name: TokenSyntax,
                               secondName: TokenSyntax? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
    FunctionParameterSyntax(
      firstName: name,
      secondName: secondName,
      colon: .colonToken(),
      type: type,
      defaultValue: def
    )
  }

  /// `name: type` with optional name and default
  @inlinable @inline(__always)
  public static func enumParam(_ name: String? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
    enumParam(
      name.map { q.tok.id($0) },
      type,
      default: def
    )
  }

  /// `name: type` with optional name and default
  @inlinable @inline(__always)
  public static func enumParam(_ name: TokenSyntax? = nil,
                               _ type: TypeSyntax,
                               default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
    EnumCaseParameterSyntax(
      firstName: name,
      colon: name == nil ? nil : .colonToken(trailingTrivia: .space),
      type: type,
      defaultValue: def
    )
  }

  /// Initializer with params & body
  @inlinable @inline(__always)
  public static func `init`(_ params: FunctionParameterListSyntax,
                            @qstmts _ body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
    InitializerDeclSyntax(
      initKeyword: .keyword(.`init`),
      signature: FunctionSignatureSyntax(parameterClause: FunctionParameterClauseSyntax(parameters: params)),
      body: qbody(body)
    )
  }

  /// Convenience overload: array of params
  @inlinable @inline(__always)
  public static func `init`(_ params: [FunctionParameterSyntax],
                            @qstmts _ body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
    `init`(
      FunctionParameterListSyntax(
        params.enumerated().map { index, param in
          param.with(
            \.trailingComma,
             index < params.count - 1 ? .commaToken(trailingTrivia: .space) : nil
          )
        }
      ),
      body
    )
  }
}


public let _wildcard = TokenSyntax.wildcardToken()


/// `name: type` with optional default
@inlinable @inline(__always)
public func _funcParam(_ name: String,
                       secondName: String? = nil,
                       _ type: TypeSyntax,
                       default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
  q.funcParam(name, secondName: secondName, type, default: def)
}

/// `name: type` with optional default
@inlinable @inline(__always)
public func _funcParam(_ name: TokenSyntax,
                       secondName: TokenSyntax? = nil,
                       _ type: TypeSyntax,
                       default def: InitializerClauseSyntax? = nil) -> FunctionParameterSyntax {
  q.funcParam(name, secondName: secondName, type, default: def)
}

/// `name: type` with optional name and default
@inlinable @inline(__always)
public func _enumParam(_ name: String? = nil,
                       _ type: TypeSyntax,
                       default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
  q.enumParam(name, type, default: def)
}

/// `name: type` with optional name and default
@inlinable @inline(__always)
public func _enumParam(_ name: TokenSyntax? = nil,
                       _ type: TypeSyntax,
                       default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
  q.enumParam(name, type, default: def)
}

/// `type` with optional default
@inlinable @inline(__always)
public func _enumParam(_ type: TypeSyntax,
                       default def: InitializerClauseSyntax? = nil) -> EnumCaseParameterSyntax {
  q.enumParam(nil as String?, type, default: def)
}
