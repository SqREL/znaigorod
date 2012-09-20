@init_vk_like = () ->
  VK.init
    apiId: 3134251
    onlyWidgets: true

  page_image = $(".content_wrapper .content .tabs .info .image img").attr("src")
  page_title = $(".content_wrapper .content .tabs .head h1").text()
  page_description = $(".content_wrapper .content .tabs .info .description .text").text()
  VK.Widgets.Like "vk_like",
    type: "mini"
    height: 18
    pageImage: if page_image then page_image else ""
    pageTitle: page_title
    pageDescription: page_description
