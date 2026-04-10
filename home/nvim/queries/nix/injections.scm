; extends

; Highlight Lua in inline Nix strings that are actually Lua code.
((apply_expression
   function: (variable_expression) @_func
   argument: (indented_string_expression
     (string_fragment) @injection.content @nix.lua.background))
 (#match? @_func "^mkLuaInline$")
 (#set! injection.combined)
 (#set! injection.language "lua"))

; Highlight file contents written out via writeText based on the target filename.
((apply_expression
   function: (apply_expression
     function: (select_expression
       attrpath: (attrpath
         (identifier) @_func))
     argument: (string_expression
       (string_fragment) @injection.filename))
   argument: (indented_string_expression
     (string_fragment) @injection.content @nix.lua.background))
 (#match? @_func "^writeText$")
 (#match? @injection.filename "\\.lua$")
 (#set! injection.combined)
 (#set! injection.language "lua"))

((apply_expression
   function: (apply_expression
     function: (select_expression
       attrpath: (attrpath
         (identifier) @_func))
     argument: (string_expression
       (string_fragment) @injection.filename))
   argument: (indented_string_expression
     (string_fragment) @injection.content))
 (#match? @_func "^writeText$")
 (#match? @injection.filename "\\.(sh|bash)$")
 (#set! injection.language "bash"))

((apply_expression
   function: (apply_expression
     function: (select_expression
       attrpath: (attrpath
         (identifier) @_func))
     argument: (string_expression
       (string_fragment) @injection.filename))
   argument: (indented_string_expression
     (string_fragment) @injection.content))
 (#match? @_func "^writeText$")
 (#match? @injection.filename "\\.sql$")
 (#set! injection.language "sql"))
