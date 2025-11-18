import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

import QDSL


/// Добавляет tryInit-версии для большинства конструкторов класса, структуры или енума.
///
/// tryInit-версия принимает параметры в форме Result<...>,
/// и проверяет, есть ли ошибки среди этих Result-параметров.
///
/// Если есть ошибки, она возвращает `Result.failure(...)`, содержащий все ошибки.
///
/// Если ошибок нет, она вызывает оригинальный конструктор и оборачивает его результат в `Result.success(...)`.
///
/// tryInit-версии не генерируются для конструкторов, содержащих только анонимные параметры:
/// ```
/// init(_: String = "",
///      x _: Bool,
///      _ _: Double = 1.1) {
///   ...
/// }
/// ```
public struct TryInitMacro {}


extension TryInitMacro: MemberMacro {

  public static func expansion(of node: AttributeSyntax,
                               providingMembersOf declaration: some DeclGroupSyntax,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    try tryInits(declaration: declaration)
  }

  private static func tryInits(declaration: some DeclGroupSyntax) throws -> [DeclSyntax] {
    guard let typeName = declaration.asNamedDeclaration?.name
    else { return [] }

    var tryInits = declaration.initializers.compactMap {
      tryInit(originalInitializerDecl: $0, typeName: typeName)
    }

    if let someEnum = declaration.as(EnumDeclSyntax.self) {
      tryInits += tryInitObject(enumDecl: someEnum).asSequence
    }

    return tryInits
  }

  private static func tryInitObject(enumDecl: EnumDeclSyntax) -> DeclSyntax? {
    let nonTrivialCases = enumDecl.memberBlock.members
      .compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
      .filter { $0.elements.contains(where: \.isNonTrivial) }

    guard nonTrivialCases.isNotEmpty else { return nil }

    return DeclSyntax(
      _enum("tryInit", modifiers: enumDecl.visibilityPrefix) {
        for nonTrivialCase in nonTrivialCases {
          for caseElement in nonTrivialCase.nonTrivialElements {
            tryInit(
              enumCaseElement: caseElement,
              enumCase: nonTrivialCase,
              enumDecl: enumDecl
            )!
          }
        }
      }
    )
  }

  private static func tryInit(enumCaseElement: EnumCaseElementSyntax,
                              enumCase: EnumCaseDeclSyntax,
                              enumDecl: EnumDeclSyntax) -> DeclSyntax? {
    guard enumCaseElement.parameterClause?.parameters.isNotEmpty == true else { return nil }

    return tryInit(
      originalFunctionDecl: .init(
        leadingTrivia: enumCase.leadingTrivia,
        attributes: enumCase.attributes,
        modifiers: enumDecl.modifiers.filter { $0.name.tokenKind != .keyword(.indirect) },
        name: enumCaseElement.name,
        genericParameterClause: nil,
        signature: .init(
          parameterClause: .init(
            parameters: .init(
              enumCaseElement.parameterClause?.parameters.enumerated().map { index, parameter in
                parameter.asFunctionParameter(index: index)
              } ?? []
            )
          ),
          returnClause: ReturnClauseSyntax(
            type: _t(enumDecl.name)
          )
        ),
        genericWhereClause: nil,
        body: nil,
        trailingTrivia: enumCase.trailingTrivia
      ),
      typeName: enumDecl.name
    )
  }

  private static func tryInit(originalInitializerDecl: InitializerDeclSyntax,
                              typeName: TokenSyntax) -> DeclSyntax? {
    let parameters = originalInitializerDecl.signature.parameterClause.parameters

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.hasInnerName) else { return nil }

    return DeclSyntax(
      _func(
        "tryInit",
        modifiers:
          originalInitializerDecl.modifiers
          .filter { $0.name.tokenKind != .keyword(.required) }
        + [m.static],
        generics: _gen.params(
          (originalInitializerDecl.genericParameterClause?.parameters ?? [])
          + [
            _gen.param("SomeError", inherits: _t("ComposableError"))
          ]),
        params: _funcParams {
          for (index, p) in parameters.enumerated() {
            p.asTryInitParameter(index: index, error: "SomeError")
          }
        },
        returns: _t(
          _result:
            _t(typeName).optIf(originalInitializerDecl.isOptional),
          _t("SomeError")
        ),
        whereClause: originalInitializerDecl.genericWhereClause,
        body: {
//      var errors: [String: SomeError] = [:]
          _var(
            "errors",
            _t(_dictionary: _t("String"), _t("SomeError")),
            ^=_emptyDictionaryLiteral
          )

//        param1.asError.map { errors["param1"] = $0 }
//        param2.asError.map { errors["param2"] = $0 }
//        ...
          for innerName in parameters.compactMap(\.innerName) {
            _ref(innerName)
              .dot("asError")
              .dot("map").call(trailingClosure: _closure {
                _ref("errors").subscript(_string(innerName.text)) ^=== _ref("$0")
              })
          }

//      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
//        return .failure(.composed(from: nonEmptyErrors))
//      }
          _ifLet(
            "nonEmptyErrors",
            _e(_t("NonEmpty")).call(
              "rawValue" <- _ref("errors")
            )
          ) {
            _return(
              _dot("failure").call(_dot("composed").call(
                "from" <- _ref("nonEmptyErrors"))
              )
            )
          }

//        return try! .success(
//          .init(
//            param1: param1.get(),
//            param2: param2.get(),
//            ...
//          )
//        )
          _return(
            _dot("success").call(
              _dot(_token_init).call(
                parameters.enumerated().map { index, param in
                  if let name = param.innerName {
                    param.outerName <- _ref(name).dot("get").call()
                  } else {
                    param.outerName <- _ref("_\(index)")
                  }
                }
              )
            )
            .asForceTry
          )
        }
      )
    )
  }

  private static func tryInit(originalFunctionDecl: FunctionDeclSyntax,
                              typeName: TokenSyntax) -> DeclSyntax? {
    let parameters = originalFunctionDecl.signature.parameterClause.parameters

    // Если у исходного конструктора нет параметров или если все параметры анонимные,
    // нет смысла делать для него tryInit-версию.
    guard parameters.contains(where: \.hasInnerName) else { return nil }

    return DeclSyntax(
      _func(
        originalFunctionDecl.name,
        modifiers:
          originalFunctionDecl.modifiers
          .filter { $0.name.tokenKind != .keyword(.required) }
        + [m.static],
        generics: _gen.params(
          (originalFunctionDecl.genericParameterClause?.parameters ?? [])
          + [
            _gen.param("SomeError", inherits: _t("ComposableError"))
          ]),
        params: _funcParams {
          for (index, p) in parameters.enumerated() {
            p.asTryInitParameter(index: index, error: "SomeError")
          }
        },
        returns: _t(
          _result:
            _t(typeName).optIf(originalFunctionDecl.doesReturnOptional),
          _t("SomeError")
        ),
        whereClause: originalFunctionDecl.genericWhereClause,
        body: {
//      var errors: [String: SomeError] = [:]
          _var(
            "errors",
            _t(_dictionary: _t("String"), _t("SomeError")),
            ^=_emptyDictionaryLiteral
          )

//        param1.asError.map { errors["param1"] = $0 }
//        param2.asError.map { errors["param2"] = $0 }
//        ...
          for innerName in parameters.compactMap(\.innerName) {
            _ref(innerName)
              .dot("asError")
              .dot("map").call(trailingClosure: _closure {
                _ref("errors").subscript(_string(innerName.text)) ^=== _ref("$0")
              })
          }

//      if let nonEmptyErrors = NonEmpty(rawValue: errors) {
//        return .failure(.composed(from: nonEmptyErrors))
//      }
          _ifLet(
            "nonEmptyErrors",
            _e(_t("NonEmpty")).call("rawValue" <- _ref("errors"))
          ) {
            _return(
              _dot("failure").call(_dot("composed").call("from" <- _ref("nonEmptyErrors")))
            )
          }

//        return try! .success(
//          myStaticFunc(
//            param1: param1.get(),
//            param2: param2.get(),
//            ...
//          )
//        )
          _return(
            _dot("success").call(
              _dot(originalFunctionDecl.name).call(
                parameters.enumerated().map { index, param in
                  if let name = param.innerName {
                    param.outerName <- _ref(name).dot("get").call()
                  } else {
                    param.outerName <- _ref("_\(index)")
                  }
                }
              )
            )
            .asForceTry
          )
        }
      )
    )
  }
}


extension EnumCaseDeclSyntax {

  var nonTrivialElements: [EnumCaseElementSyntax] {
    elements.filter(\.isNonTrivial)
  }
}


extension EnumCaseElementSyntax {

  var isNonTrivial: Bool {
    parameterClause?.parameters.isNotEmpty == true
  }
}


extension FunctionParameterSyntax {

  /// If the parameter is named, wraps it in `Result<Wrapped, ErrorType>` and default to `.success(oldDefault)`.
  /// Otherwise, renames it to "_index" and doesn't wrap it at all.
  public func asTryInitParameter(index: Int,
                                 error: String = "SomeError") -> FunctionParameterSyntax {
    if hasInnerName {
      self
        .with(
          \.type,
           _t(_result: type.withoutEscapingIfNecessary, _t(error))
        )
        .with(
          \.defaultValue,
           defaultValue.map { ^=_success($0.value) }
        )
    } else {
      with(\.secondName, _token("_\(index)"))
    }
  }

  var hasInnerName: Bool {
    hasNonEmptySecondName
    || (secondName == nil && hasNonEmptyFirstName)
  }

  var hasNonEmptyFirstName: Bool {
    firstName.tokenKind != .wildcard
  }

  var hasNonEmptySecondName: Bool {
    (secondName != nil) && (secondName?.tokenKind != .wildcard)
  }

  var isNamed: Bool {
    !isUnnamed
  }

  var isUnnamed: Bool {
    firstName.tokenKind == .wildcard
    && (secondName?.tokenKind == .wildcard || secondName == nil)
  }

  var outerName: TokenSyntax? {
    switch firstName.tokenKind {
    case .wildcard: nil
    default: firstName
    }
  }

  var innerName: TokenSyntax? {
    switch secondName?.tokenKind {
    case .wildcard: nil
    default: secondName ?? outerName
    }
  }
}


extension InitializerDeclSyntax {

  var isOptional: Bool {
    optionalMark?.tokenKind == .postfixQuestionMark
  }
}


extension FunctionDeclSyntax {

  var doesReturnOptional: Bool {
    signature.returnClause?.type.is(OptionalTypeSyntax.self) == true
  }
}


extension EnumCaseParameterSyntax {

  func asFunctionParameter(index: Int) -> FunctionParameterSyntax {
    .init(
      firstName: firstName ?? .wildcardToken(),
      secondName: firstName == nil ? _token("_\(index)") : nil,
      type: type,
      defaultValue: defaultValue,
      trailingComma: .commaToken()
    )
  }
}


private extension Optional {

  var asSequence: [Wrapped] {
    self.map { [$0] } ?? []
  }

  func filter(_ condition: (Wrapped) -> Bool) -> Self {
    switch self {
    case .some(let wrapped) where condition(wrapped): wrapped
    default: nil
    }
  }

  func getOrElse(_ wrapped: Wrapped) -> Wrapped {
    self ?? wrapped
  }
}
