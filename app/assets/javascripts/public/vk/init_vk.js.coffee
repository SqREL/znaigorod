VK.init
  apiId: 3136085 # znaigorod.ru
  #apiId: 3136087 # znaigorod.openteam.ru
  onlyWidgets: true

@init_vk_like = () ->
  VK.Widgets.Like "vk_like",
    type: "mini"
    height: 18
  true

@init_vk_recommended = () ->
  VK.Widgets.Recommended "vk_recommended"
    limit: 5
    period: 'month'
    sort: 'likes'
  true

@init_vk_comments = () ->
  VK.Widgets.Comments "vk_comments"
    limit: 10
    width: "760"
    attach: "*"
  true

@init_vk_group_thin = () ->
  VK.Widgets.Group "vk_groups_thin"
    mode: 0
    width: "200"
    height: "360"
  , 35689602
  true

@init_vk_group_thick = () ->
  VK.Widgets.Group "vk_groups_thick"
    mode: 0
    width: "285"
    height: "360"
  , 35689602
  true
