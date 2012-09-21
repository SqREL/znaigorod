VK.init
  apiId: 3134248
  onlyWidgets: true

@init_vk_like = () ->
  VK.Widgets.Like "vk_like",
    type: "mini"
    height: 18

@init_vk_recommended = () ->
  VK.Widgets.Recommended "vk_recommended"
    limit: 5
    period: 'month'
    sort: 'likes'
