import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


@main
struct QDSLMacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    TryInitMacro.self
  ]
}
