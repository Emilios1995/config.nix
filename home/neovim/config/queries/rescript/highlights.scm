;; vim: ft=query
;; extends

;; Top-level let bindings (file level)
(source_file
  (let_declaration
    (let_binding
      pattern: (value_identifier) @AlabasterDefinition)))

;; Top-level let bindings (module level)
(module_binding
  definition: (block
    (let_declaration
      (let_binding
        pattern: (value_identifier) @AlabasterDefinition))))

;; Type declarations (file level)
(source_file
  (type_declaration
    (type_binding
      name: (type_identifier) @AlabasterDefinition)))

;; Type declarations (module level)
(module_binding
  definition: (block
    (type_declaration
      (type_binding
        name: (type_identifier) @AlabasterDefinition))))

;; Module declarations
(module_binding
  name: (module_identifier) @AlabasterDefinition)

;; Variant constructors
(variant_declaration
  (variant_identifier) @AlabasterDefinition)

;; External declarations (file level)
(source_file
  (external_declaration
    (value_identifier) @AlabasterDefinition))

;; External declarations (module level)
(module_binding
  definition: (block
    (external_declaration
      (value_identifier) @AlabasterDefinition)))
