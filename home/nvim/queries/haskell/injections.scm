((quasiquote
  (quoter) @injection.language
  (quasiquote_body) @injection.content)
  (#match? @injection.language "^TH\..*Statement$")
  (#set! injection.language "sql"))
