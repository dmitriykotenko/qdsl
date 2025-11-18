import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension VariableDeclSyntax {

  var isSingleVariable: Bool { bindings.count == 1 }

  var isStatic: Bool {
    modifiers.contains { $0.name.tokenKind == .keyword(.static) }
  }

  var isStoredProperty: Bool {
    isSingleVariable && !isStatic && bindings.first?.accessorBlock == nil
  }

  var asStoredProperty: StoredProperty? {
    guard isStoredProperty else { return nil }

    return bindings.first.flatMap {
      StoredProperty(
        kind: bindingSpecifier.text,
        name: $0.pattern.as(IdentifierPatternSyntax.self)?.identifier,
        typeDecl: $0.typeAnnotation?.type,
        defaultValueDecl: $0.initializer
      )
    }
  }
}
