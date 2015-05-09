# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editQuestionLink =  ($doc) ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

$(document).ready(editQuestionLink)
$(document).on('page:load', editQuestionLink)
$(document).on('page:update', editQuestionLink)
