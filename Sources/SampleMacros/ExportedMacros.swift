@attached(member, names: named(tryInit))
@available(swift 5.9)
public macro TryInit() = #externalMacro(
  module: "SampleMacros",
  type: "TryInitMacro"
)
