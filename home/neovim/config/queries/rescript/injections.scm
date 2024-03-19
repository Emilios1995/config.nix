; extends


((comment) @injection.content (#set! injection.language "comment"))

(extension_expression
  (extension_identifier) @_name
  (#eq? @_name "relay")
  (expression_statement
    (_ (_) @injection.content (#set! injection.language "graphql") )))

(jsx_attribute 
  (property_identifier) @prop
  (string
    (string_fragment) @injection.content (#set! injection.language "tailwind"))
  (#eq? @prop "className"))
