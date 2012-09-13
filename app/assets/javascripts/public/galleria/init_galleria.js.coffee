@init_galleria = () ->

  $('.gallery_container').galleria
    easing: 'galleriaIn'
    imageCrop: 'landscape'
    lightbox: true
    overlayBackground: '#fff'
    overlayOpacity: '0.5'
    preload: 3
    showCounter: false
    showFullscreen: true
    showInfo: true
    _toggleInfo: false
    thumbnails: true
    transition: 'slide'
    transitionSpeed: 500
    width: 740
