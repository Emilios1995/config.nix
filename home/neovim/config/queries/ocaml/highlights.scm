;; vim: ft=query
;; extends

;; Function and value definitions
(compilation_unit
  (value_definition
    (let_binding
      pattern: (value_name) @AlabasterDefinition)))

(type_definition
  (type_binding
    name: (type_constructor) @AlabasterDefinition))

;; Module definitions
(module_definition
  (module_binding
    (module_name) @AlabasterDefinition))

;; Variant constructors
(constructor_declaration
   (constructor_name) @AlabasterDefinition)

(type_binding "->" @AlabasterPunctuation)
("|" @AlabasterPunctuation)

;; Constants
(boolean) @AlabasterConstant
(unit) @AlabasterConstant

