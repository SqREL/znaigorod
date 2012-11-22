@init_3dtourme_stat = () ->
  link = $('a.3dtourme')
  link.click (event) ->
    yaCounter14923525.reachGoal("3dtourme") unless link.hasClass("development")
    true
  true

@init_prokachkov_stat = () ->
  link = $('a.prokachkov')
  link.click (event) ->
    yaCounter14923525.reachGoal("prokachkov") unless link.hasClass("development")
    true
  true
