; extends

(jsx_attribute
  (property_identifier) @prop
  (jsx_expression
    (template_string 
      (string_fragment) @injection.content (#set! injection.language "tailwind")))
  (#eq? @prop "className"))

