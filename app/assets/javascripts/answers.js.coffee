# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Handlebars.registerHelper 'link', (object) ->
  url = Handlebars.escapeExpression(object.url)
  text = object.url.split('/').pop()
  return new Handlebars.SafeString "<a href=" + url + ">" + text + "</a>"

# processingJsonForAnswer = ($buttonClass, $xhr) ->
#   answer = $.parseJSON($xhr.responseText)
#   if $buttonClass == ".new_answer"
#     $.when($('.answers').append(HandlebarsTemplates['answers/create'](answer)))
#      .done ->
#       editAnswerLink('.new_answer')
#     $('.new_answer').find('textarea').val('')
#   if $buttonClass == ".edit_answer"
#     $.when($('#answer_' + answer.id).replaceWith(HandlebarsTemplates['answers/create'](answer)))
#       .done ->
#       editAnswerLink('.answers')

# processingJsonAnswerErrors = ($xhr) ->
#   errors = $.parseJSON($xhr.responseText)
#   $.each errors, (index, value) ->
#     $('.answer-errors').html("<div class='alert alert-danger'>" + value + "</div>")

subscribeForQuestion = ->
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId
  currentUser = $('.user-auth').data('currentUser')
  PrivatePub.subscribe channel, (data, channel) ->
    console.log(data)
    answer = $.parseJSON(data['answer'])
    type = data['type']
    author = data['author']
    if author != currentUser
      if type == "new"
        $.when($('.answers').append(HandlebarsTemplates['answers/create4all'](answer)))
         .done ->
          editAnswerLink('.answers')
        $('.new_answer').find('textarea').val('')
      if type == "update"
        $.when($('#answer_' + answer.id).replaceWith(HandlebarsTemplates['answers/create4all'](answer)))
        .done ->
        editAnswerLink('.answers')
    else
      console.log('Author')

editAnswerLink =  ($doc) ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

$(document).ready(editAnswerLink)
$(document).ready(subscribeForQuestion)
$(document).on('page:load', editAnswerLink)
$(document).on('page:update', editAnswerLink)