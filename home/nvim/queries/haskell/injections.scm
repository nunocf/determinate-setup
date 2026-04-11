; extends

((quasiquote
  (quoter) @_name
  (quasiquote_body) @injection.content)
  (#match? @_name "^TH\..*Statement$")
  (#set! injection.language "sql"))
