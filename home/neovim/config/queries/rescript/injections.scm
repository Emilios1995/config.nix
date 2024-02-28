; extends

(extension_expression
  (extension_identifier) @_name
  (#eq? @_name "relay")
  (expression_statement
    (_ (_) @injection.content (#set! injection.language "graphql") )))
