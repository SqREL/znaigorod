@init_common = () ->
  $('a.disabled').click ->
    false

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)

String.prototype.trim = () ->
  this.replace(/^\s+|\s+$/g, "")

String.prototype.squish = () ->
  this.replace(/\s+/g, " ").trim()

String.prototype.strip_tags = () ->
  this.replace(/(<([^>]+)>)/ig, "").replace(/&nbsp;/ig, " ").replace(/&#?[a-z0-9]+;/ig, "")
