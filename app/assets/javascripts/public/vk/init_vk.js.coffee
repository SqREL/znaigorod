VK.init
# apiId: 3134251 # znaigorod.ru
  apiId: 3134248 # znaigorod.openteam.ru
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

@init_vk_comments = () ->
  VK.Widgets.Comments "vk_comments"
    limit: 10
    width: "760"
    attach: "*"
