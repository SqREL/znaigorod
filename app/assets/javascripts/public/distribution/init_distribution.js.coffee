@init_distribution = () ->
  container = $(".content .distribution")
  dates = $(".dates", container)
  $("li.text:first", dates).addClass("selected")
  $("li.selected", dates).prev("li").addClass("before_selected")
  distribution_id = $("li.selected p.date", dates).attr("data-id")
  $(".theaters[data-id=#{distribution_id}]", container).show()
  $("li.text", dates).click (event) ->
    link = $(this)
    return false if link.hasClass("selected")
    distribution_id = $("li.selected p.date", dates).attr("data-id")
    $(".theaters[data-id=#{distribution_id}]", container).slideUp("fast")
    $("li", dates).removeClass("selected").removeClass("before_selected")
    link.addClass("selected")
    link.prev("li").addClass("before_selected")
    distribution_id = $("li.selected p.date", dates).attr("data-id")
    $(".theaters[data-id=#{distribution_id}]", container).slideDown("fast")
    false
