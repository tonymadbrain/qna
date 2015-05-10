# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Handlebars.registerHelper 'link', (object) ->
  url = Handlebars.escapeExpression(object.url)
  text = object.url.split('/').pop()
  return new Handlebars.SafeString "<a href=" + url + ">" + text + "</a>"

processingJsonForAnswer = ($buttonClass, $xhr) ->
  answer = $.parseJSON($xhr.responseText)
  if $buttonClass == ".new_answer"
    $.when($('.answers').append(HandlebarsTemplates['answers/create'](answer)))
     .done ->
      editAnswerLink('.new_answer')
    $('.new_answer').find('textarea').val('')
  if $buttonClass == ".edit_answer"
    $.when($('#answer_' + answer.id).replaceWith(HandlebarsTemplates['answers/create'](answer)))
      .done ->
      editAnswerLink('.answers')

processingJsonAnswerErrors = ($xhr) ->
  errors = $.parseJSON($xhr.responseText)
  $.each errors, (index, value) ->
    $('.answer-errors').html("<div class='alert alert-danger'>" + value + "</div>")

$(document).on 'ajax:success', '.new_answer', (e, data, status, xhr) ->
  processingJsonForAnswer(".new_answer", xhr)
.bind 'ajax:error', (e, xhr, status, error) ->
  processingJsonAnswerErrors(xhr)

$(document).on 'ajax:success', '.edit_answer', (e, data, status, xhr) ->
  processingJsonForAnswer(".edit_answer", xhr)
.bind 'ajax:error', (e, xhr, status, error) ->
  processingJsonAnswerErrors(xhr)

editAnswerLink =  ($doc) ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

$(document).ready(editAnswerLink)
$(document).on('page:load', editAnswerLink)
$(document).on('page:update', editAnswerLink)