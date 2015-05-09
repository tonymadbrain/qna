# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Handlebars.registerHelper 'link', (object) ->
  url = Handlebars.escapeExpression(object.url)
  text = object.url.split('/').pop()
  return new Handlebars.SafeString "<a href=" + url + ">" + text + "</a>"

$(document).on 'ajax:success', '.new_answer', (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  $.when($('.answers').append(HandlebarsTemplates['answers/create'](answer)))
   .done ->
    editAnswerLink($(this))
  clean($(this))
.bind 'ajax:error', (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    renderError(value)
      
$(document).on 'ajax:success', '.edit_answer', (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText);
  $.when($('#answer_' + answer.id).replaceWith(HandlebarsTemplates['answers/create'](answer)))
   .done ->
    editAnswerLink($(this))
.bind 'ajax:error', (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    renderError(value)

clean = ($form) ->
  $form.find('textarea').val('')
  $form.find('.answer-errors').html('')
  $form.find('input:file').each ->
    $(this).remove() unless $(this).attr('id')

editAnswerLink =  ($doc) ->
  $('.edit-answer-link').click   (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

renderError = ($value) ->
  $('.answer-errors').html("<div class='alert alert-danger'>" + $value + "</div>")

$(document).ready(editAnswerLink)
$(document).on('page:load', editAnswerLink)
$(document).on('page:update', editAnswerLink)