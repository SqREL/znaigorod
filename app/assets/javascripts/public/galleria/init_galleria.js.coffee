@init_galleria = () ->

  $('.gallery_container').galleria
    easing: 'galleriaIn'
    lightbox: true
    overlayBackground: '#fff'
    overlayOpacity: '0.5'
    preload: 3
    showCounter: false
    showInfo: true
    thumbnails: true
    thumbCrop: 'width'
    transition: 'fade'
    transitionSpeed: 500
    width: 740
