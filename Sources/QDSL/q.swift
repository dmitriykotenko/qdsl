import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Root namespace: q

public enum q {

  // MARK: tokens
  public enum tok {
    public static let `self` = TokenSyntax.keyword(.self)
    public static let `super` = TokenSyntax.keyword(.super)
    public static let `init` = TokenSyntax.keyword(.`init`)
    public static func id(_ s: String) -> TokenSyntax { .identifier(s) }
    public static func keyword(_ keyword: Keyword) -> TokenSyntax { .keyword(keyword) }
  }

  // MARK: types
  public enum t {

    @inlinable @inline(__always)
    public static func id(_ s: String) -> TypeSyntax {
      id(tok.id(s))
    }

    @inlinable @inline(__always)
    public static func id(_ token: TokenSyntax) -> TypeSyntax {
      TypeSyntax(IdentifierTypeSyntax(name: token))
    }

    @inlinable @inline(__always)
    public static func generic(_ base: String,
                               _ args: [TypeSyntax] = []) -> TypeSyntax {
      generic(tok.id(base), args)
    }

    @inlinable @inline(__always)
    public static func generic(_ base: TokenSyntax,
                               _ args: [TypeSyntax] = []) -> TypeSyntax {
      TypeSyntax(
        IdentifierTypeSyntax(
          name: base,
          genericArgumentClause: args.isEmpty ? nil : GenericArgumentClauseSyntax(
            arguments: GenericArgumentListSyntax(
              args.enumerated().map { index, argument in
                GenericArgumentSyntax(
                  argument: .type(argument),
                  trailingComma: index < args.count - 1 ? .commaToken(trailingTrivia: .space) : nil
                )
              }
            )
          )
        )
      )
    }

    @inlinable @inline(__always)
    public static func optional(_ wrapped: TypeSyntax) -> TypeSyntax {
      TypeSyntax(OptionalTypeSyntax(wrappedType: wrapped))
    }

    @inlinable @inline(__always)
    public static func array(_ element: some TypeSyntaxProtocol) -> TypeSyntax {
      TypeSyntax(ArrayTypeSyntax(element: element))
    }

    @inlinable @inline(__always)
    public static func dictionary(_ key: some TypeSyntaxProtocol,
                                  _ value: some TypeSyntaxProtocol) -> TypeSyntax {
      TypeSyntax(DictionaryTypeSyntax(key: key, value: value))
    }

    @inlinable @inline(__always)
    public static func result(_ wrapped: TypeSyntax,
                              _ error: TypeSyntax) -> TypeSyntax {
      generic("Result", [wrapped, error])
    }
  }

  // MARK: exprs
  public enum e {

    @inlinable @inline(__always)
    public static func forceTry(_ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: .exclamationMarkToken(trailingTrivia: .space),
        expression: throwingExpr
      ))
    }

    @inlinable @inline(__always)
    public static func optionalTry(_ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: .postfixQuestionMarkToken(),
        expression: throwingExpr
      ))
    }

    @inlinable @inline(__always)
    public static func `try`(questionOrExclamationMark: TokenSyntax? = nil,
                             _ throwingExpr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(TryExprSyntax(
        tryKeyword: tok.keyword(.try),
        questionOrExclamationMark: questionOrExclamationMark,
        expression: throwingExpr
      ))
    }

    @inlinable @inline(__always)
    public static func forceUnwrap(_ expr: ExprSyntaxProtocol) -> ExprSyntax {
      ExprSyntax(ForceUnwrapExprSyntax(expression: expr))
    }

    @inlinable @inline(__always)
    public static func ref(_ name: TokenSyntax) -> ExprSyntax {
      ExprSyntax(DeclReferenceExprSyntax(baseName: name))
    }

    @inlinable @inline(__always)
    public static func ref(_ name: String) -> ExprSyntax {
      ref(tok.id(name))
    }

    @inlinable @inline(__always)
    public static func bool(_ bool: Bool) -> ExprSyntax {
      ExprSyntax(BooleanLiteralExprSyntax(literal: .keyword(bool ? .true : .false)))
    }

    @inlinable @inline(__always)
    public static func int(_ int: Int) -> ExprSyntax {
      ExprSyntax(IntegerLiteralExprSyntax(literal: .integerLiteral(String(int))))
    }

    @inlinable @inline(__always)
    public static func string(_ string: String) -> ExprSyntax {
      ExprSyntax(
        StringLiteralExprSyntax(content: string)
      )
    }

    @inlinable @inline(__always)
    public static func emptyArrayLiteral() -> ExprSyntax {
      ExprSyntax(
        ArrayExprSyntax(elements: .init([]))
      )
    }

    @inlinable @inline(__always)
    public static func arrayLiteral(
      @qarray_elements _ content: () -> [ArrayElementSyntax]
    ) -> ExprSyntax {
      ExprSyntax(
        ArrayExprSyntax(elements: .init(content()))
      )
    }

    @inlinable @inline(__always)
    public static func emptyDictionaryLiteral() -> ExprSyntax {
      ExprSyntax(
        DictionaryExprSyntax(content: .colon(.colonToken()))
      )
    }

    @inlinable @inline(__always)
    public static func dictionaryLiteral(
      @qdictionary_elements _ content: () -> [DictionaryElementSyntax]
    ) -> ExprSyntax {
      ExprSyntax(
        DictionaryExprSyntax(content: .elements(.init(content())))
      )
    }

    /// Converts a TypeSyntax into an expression (for constructor calls).
    @inlinable @inline(__always)
    public static func type(_ ty: TypeSyntax) -> ExprSyntax {
      ExprSyntax(TypeExprSyntax(type: ty))
    }

    @inlinable @inline(__always)
    public static func reference(_ reference: DeclReferenceExprSyntax) -> ExprSyntax {
      ExprSyntax(reference)
    }

    /// Build `\Root.property`
    @inlinable @inline(__always)
    public static func keyPath(_ root: (some TypeSyntaxProtocol)? = TypeSyntax?.none,
                               _ name: String) -> ExprSyntax {
      keyPath(root, _token(name))
    }

    /// Build `\Root.property`
    @inlinable @inline(__always)
    public static func keyPath(_ root: (some TypeSyntaxProtocol)? = TypeSyntax?.none,
                               _ name: TokenSyntax) -> ExprSyntax {
      ExprSyntax(
        KeyPathExprSyntax(
          root: root,
          components: KeyPathComponentListSyntax([
            .init(
              period: .periodToken(),
              component: .property(
                KeyPathPropertyComponentSyntax(
                  declName: DeclReferenceExprSyntax(baseName: name)
                )
              )
            )
          ])
        )
      )
    }

    @inlinable @inline(__always)
    public static func closure(_ closure: ClosureExprSyntax) -> ExprSyntax {
      ExprSyntax(closure)
    }

    /// self.member
    @inlinable @inline(__always)
    public static func self_dot(_ name: TokenSyntax) -> ExprSyntax {
      return ExprSyntax(
        MemberAccessExprSyntax(
          base: DeclReferenceExprSyntax(baseName: tok.`self`),
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: name)
        )
      )
    }

    /// self.member
    @inlinable @inline(__always)
    public static func self_dot(_ name: String) -> ExprSyntax {
      self_dot(tok.id(name))
    }

    /// .member
    @inlinable @inline(__always)
    public static func dot(_ name: String) -> ExprSyntax {
      dot(tok.id(name))
    }

    /// .member
    @inlinable @inline(__always)
    public static func dot(_ name: TokenSyntax) -> ExprSyntax {
#if swift(>=5.10)
      return ExprSyntax(
        MemberAccessExprSyntax(
          period: .periodToken(),
          declName: DeclReferenceExprSyntax(baseName: name)
        )
      )
#else
      return ExprSyntax(
        MemberAccessExprSyntax(base: nil, dot: .periodToken(), name: name)
      )
#endif
    }

    /// lhs = rhs
    @inlinable @inline(__always)
    public static func assign2(_ left: ExprSyntax,
                               _ right: ExprSyntax) -> ExprSyntax {
      ExprSyntax(
        SequenceExprSyntax {
          left
          ExprSyntax(AssignmentExprSyntax(
            equal: .equalToken(),
          ))
          right
        }
      )
    }

    /// self.x = x
    @inlinable @inline(__always)
    public static func assignSelf2(_ name: String) -> ExprSyntax { assign2(self_dot(name), ref(name)) }
  }
}


public let _nil = ExprSyntax(NilLiteralExprSyntax())


@inlinable @inline(__always)
public func _bool(_ bool: Bool) -> ExprSyntax {
  q.e.bool(bool)
}


@inlinable @inline(__always)
public func _int(_ int: Int) -> ExprSyntax {
  q.e.int(int)
}

@inlinable @inline(__always)
public func _string(_ string: String) -> ExprSyntax {
  q.e.string(string)
}


extension TypeSyntax {

  @inlinable @inline(__always)
  public func _t(_ name: String,
                 genericArgs: [TypeSyntax] = []) -> TypeSyntax {
    _t(
      q.tok.id(name),
      genericArgs: genericArgs
    )
  }

  @inlinable @inline(__always)
  public func _t(_ token: TokenSyntax,
                 genericArgs: [TypeSyntax] = []) -> TypeSyntax {
    TypeSyntax(MemberTypeSyntax(
      baseType: self,
      name: token,
      genericArgumentClause: genericArgs.isEmpty ? nil : GenericArgumentClauseSyntax(
        arguments: GenericArgumentListSyntax(
          genericArgs.enumerated().map { index, argument in
            GenericArgumentSyntax(
              argument: .type(argument),
              trailingComma: genericArgs.trailingComma(forIndex: index)
            )
          }
        )
      )
    ))
  }
}


public extension q {

  /// `.success(expr)`
  @inlinable @inline(__always)
  static func success(_ e: ExprSyntax) -> ExprSyntax {
    q.e.dot("success").call(e)
  }

  /// Wrap parameter in `Result<Wrapped, ErrorType>` and default to `.success(oldDefault)`
  @inlinable @inline(__always)
  static func wrapParamInResult(_ p: FunctionParameterSyntax,
                                error: String = "SomeError") -> FunctionParameterSyntax {
    p
      .with(
        \.type,
         _t(_result: p.type.withoutEscapingIfNecessary, _t(error))
      )
      .with(
        \.defaultValue,
         p.defaultValue.map { ^=success($0.value) }
      )
  }
}


//public typealias _e = q.e


/// `.success(expr)`
@inlinable @inline(__always)
public func _success(_ e: ExprSyntax) -> ExprSyntax {
  _dot("success").call(e)
}


@inlinable @inline(__always)
public func _ref(_ s: String) -> ExprSyntax { q.e.ref(s) }

@inlinable @inline(__always)
public func _ref(_ s: TokenSyntax) -> ExprSyntax { q.e.ref(s) }

public let _ref_self = DeclReferenceExprSyntax(baseName: q.tok.`self`)
public let _self = q.tok.`self`
public let _super = q.tok.`super`

@inlinable @inline(__always)
public func _dot(_ s: String) -> ExprSyntax { q.e.dot(s) }

@inlinable @inline(__always)
public func _dot(_ s: TokenSyntax) -> ExprSyntax { q.e.dot(s) }

@inlinable @inline(__always)
public func _self_dot(_ name: TokenSyntax) -> ExprSyntax { q.e.self_dot(name) }

@inlinable @inline(__always)
public func _self_dot(_ name: String) -> ExprSyntax { q.e.self_dot(name) }

public let _dot_init: ExprSyntax = q.e.dot(q.tok.`init`)

@inlinable @inline(__always)
public func _namedType(_ name: String) -> ExprSyntax {
  q.e.type(q.t.id(name))
}

@inlinable @inline(__always)
public func _t(_ base: String,
                          _ args: [TypeSyntax] = []) -> TypeSyntax {
  q.t.generic(base, args)
}

@inlinable @inline(__always)
public func _t(_ base: TokenSyntax,
                          _ args: [TypeSyntax] = []) -> TypeSyntax {
  q.t.generic(base, args)
}

@inlinable @inline(__always)
public func _t(_array element: TypeSyntax) -> TypeSyntax {
  q.t.array(element)
}

@inlinable @inline(__always)
public func _t(_dictionary key: TypeSyntax,
                          _ value: TypeSyntax) -> TypeSyntax {
  q.t.dictionary(key, value)
}

@inlinable @inline(__always)
public func _t(_result success: TypeSyntax,
                          _ failure: TypeSyntax) -> TypeSyntax {
  q.t.result(success, failure)
}

public let _t_Self = _t(.keyword(.Self))

public let _emptyDictionaryLiteral: ExprSyntax = q.e.emptyDictionaryLiteral()

@inlinable @inline(__always)
public func _dictionaryLiteral(
  @qdictionary_elements _ content: () -> [DictionaryElementSyntax]
) -> ExprSyntax {
  q.e.dictionaryLiteral(content)
}

public let _emptyArrayLiteral: ExprSyntax = q.e.emptyArrayLiteral()

@inlinable @inline(__always)
public func _arrayLiteral(
  @qarray_elements _ content: () -> [ArrayElementSyntax]
) -> ExprSyntax {
  q.e.arrayLiteral(content)
}

infix operator ^&


extension TypeSyntax {

  @inlinable @inline(__always)
  public var opt: TypeSyntax {
    q.t.optional(self)
  }

  @inlinable @inline(__always)
  public func optIf(_ condition: Bool) -> TypeSyntax {
    condition ? opt : self
  }

  @inlinable @inline(__always)
  public static func ^& (this: TypeSyntax,
                         that: TypeSyntax) -> TypeSyntax {
    TypeSyntax(
      CompositionTypeSyntax(elements: .init([
        .init(type: this, ampersand: .prefixAmpersandToken(trailingTrivia: .space)),
        .init(type: that)
      ]))
    )
  }
}


/// Function with generics/where (body builder).
@inlinable @inline(__always)
public func _func(_ name: String,
                  modifiers: DeclModifierListSyntax = [],
                  generics: GenericParameterClauseSyntax? = nil,
                  params: FunctionParameterListSyntax = _funcParams { },
                  returns: TypeSyntax? = nil,
                  whereClause: GenericWhereClauseSyntax? = nil,
                  @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
  _func(
    q.tok.id(name),
    modifiers: modifiers,
    generics: generics,
    params: params,
    returns: returns,
    whereClause: whereClause,
    body: body
  )
}

@inlinable @inline(__always)
public func _func(_ name: TokenSyntax,
                  modifiers: DeclModifierListSyntax = [],
                  generics: GenericParameterClauseSyntax? = nil,
                  params: FunctionParameterListSyntax = _funcParams { },
                  returns: TypeSyntax? = nil,
                  whereClause: GenericWhereClauseSyntax? = nil,
                  @qstmts body: () -> [CodeBlockItemSyntax]) -> FunctionDeclSyntax {
  qdecl_ext.func(
    name,
    modifiers: modifiers,
    generics: generics,
    params: params,
    returns: returns,
    whereClause: whereClause,
    body: body
  )
}

/// Initializer with generics/where (body builder).
@inlinable @inline(__always)
public func _init(modifiers: DeclModifierListSyntax = [],
                             generics: GenericParameterClauseSyntax? = nil,
                             params: FunctionParameterListSyntax,
                             whereClause: GenericWhereClauseSyntax? = nil,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> InitializerDeclSyntax {
  qdecl_ext.`init`(
    modifiers: modifiers,
    params: params,
    generics: generics,
    whereClause: whereClause,
    body: body
  )
}


@inlinable @inline(__always)
public func _token(_ s: String) -> TokenSyntax { .identifier(s) }

public let _token_init: TokenSyntax = q.tok.`init`

public typealias k = Keyword



/// Converts a TypeSyntax into an expression (for constructor calls).
@inlinable @inline(__always)
public func _e(_ type: TypeSyntax) -> ExprSyntax {
  q.e.type(type)
}


@inlinable @inline(__always)
public func _e(_ closure: ClosureExprSyntax) -> ExprSyntax {
  q.e.closure(closure)
}


extension FunctionParameterSyntax {

  @inlinable @inline(__always)
  public var hasInnerName: Bool {
    hasNonEmptySecondName
    || (secondName == nil && hasNonEmptyFirstName)
  }

  @inlinable @inline(__always)
  public var hasNonEmptyFirstName: Bool {
    firstName.tokenKind != .wildcard
  }

  @inlinable @inline(__always)
  public var hasNonEmptySecondName: Bool {
    secondName != nil && secondName?.tokenKind != .wildcard
  }

  @inlinable @inline(__always)
  public var isNamed: Bool {
    !isUnnamed
  }

  @inlinable @inline(__always)
  public var isUnnamed: Bool {
    firstName.tokenKind == .wildcard
    && (secondName?.tokenKind == .wildcard || secondName == nil)
  }

  @inlinable @inline(__always)
  public var outerName: TokenSyntax? {
    switch firstName.tokenKind {
    case .wildcard: nil
    default: firstName
    }
  }

  @inlinable @inline(__always)
  public var innerName: TokenSyntax? {
    switch secondName?.tokenKind {
    case .wildcard: nil
    default: secondName ?? outerName
    }
  }
}


/// Build `\Root.property`
@inlinable @inline(__always)
public func _keyPath(_ name: String) -> ExprSyntax {
  q.e.keyPath(TypeSyntax?.none, _token(name))
}

/// Build `\Root.property`
@inlinable @inline(__always)
public func _keyPath(_ name: TokenSyntax) -> ExprSyntax {
  q.e.keyPath(TypeSyntax?.none, name)
}


/// Build `\Root.property`
@inlinable @inline(__always)
public func _keyPath(_ root: (some TypeSyntaxProtocol)? = TypeSyntax?.none,
                                _ name: String) -> ExprSyntax {
  q.e.keyPath(root, _token(name))
}

/// Build `\Root.property`
@inlinable @inline(__always)
public func _keyPath(_ root: (some TypeSyntaxProtocol)? = TypeSyntax?.none,
                                _ name: TokenSyntax) -> ExprSyntax {
  q.e.keyPath(root, name)
}
