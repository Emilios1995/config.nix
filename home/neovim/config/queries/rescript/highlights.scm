; extends


(record_pattern
  (value_identifier) @variable.member)

(value_identifier_path
  (module_identifier)
  (value_identifier) @variable.member)

(call_expression 
  function: (value_identifier_path
    _
    (value_identifier) @function.call))

(call_expression 
  function: (value_identifier) @function.call)


((type_identifier) @type.builtin
  (#any-of? @type.builtin
    "int" "char" "bytes" "string" "float" "bool" "unit" "exn" "array" "list" "option" "int32"
    "int64" "nativeint" "format6" "lazy_t"))


[
  "include"
  ("open")
] @keyword.import


[
  "if"
  "else"
  "switch"
  "when"
] @keyword.conditional

(let_binding 
  pattern: (value_identifier) @function
  body: (function))

(pipe_expression
  _
  (value_identifier_path
    _
    (value_identifier) @function.call))

[
 (variant_identifier)
 (polyvar_identifier)
] @constructor

(module_identifier) @module

((module_identifier) @module.builtin
  (#any-of? @module.builtin "Belt"))

(decorator_identifier) @attribute

(extension_identifier) @keyword
("%") @keyword
