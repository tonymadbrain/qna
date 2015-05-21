  # Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

Handlebars.registerHelper 'link', (object) ->
  url = Handlebars.escapeExpression(object.url)
  text = object.url.split('/').pop()
  return new Handlebars.SafeString "<a href=" + url + ">" + text + "</a>"

subscribeForQuestion = ->
  questionId = $('.answers').data('questionId')
  channel = '/questions/' + questionId
  currentUser = $('.user-auth').data('currentUser')
  PrivatePub.subscribe channel, (data, channel) ->
    console.log(data)
    if data['answer']
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
    if data['comment']
      comment_data =
        comment: $.parseJSON(data['comment'])
        user: $.parseJSON(data['user'])
      resource_type = comment_data.comment.commentable_type.toLowerCase()
      $('.' + resource_type + '-comments').append(HandlebarsTemplates['comments/create'](comment_data))
      $('form#comment_body').val('')

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