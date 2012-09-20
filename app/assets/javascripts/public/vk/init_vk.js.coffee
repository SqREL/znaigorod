@init_vk_like = () ->
  VK.init
    apiId: 3134251
    onlyWidgets: true
  VK.Widgets.Like "vk_like",
    type: "mini"
    height: 18
