$ ->
  $('.close').live 'click', (e) ->
    e.preventDefault()
    $(this).parent().hide()
  $('.devise form div i').each ->
    $this = $(this)
    text = $this.text()
    sibling = $this.prev('label')
    a = $("<a>").text("*").attr('title', text)
    a.prependTo(sibling)
  devise_errors = $('.devise #error_explanation')
  if devise_errors.length
    close_link = $('<a>').addClass('close').attr('href', '#').text('\u00d7')
    devise_errors.prepend(close_link)