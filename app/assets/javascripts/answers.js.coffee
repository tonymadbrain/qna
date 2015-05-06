# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# require templates

ready = ->
  $('.edit-answer-link').click   (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('form.new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $.when($('.answers').append(generate_answer(answer)))
     .done ->
      $('.edit-answer-link').click   (e) ->
        e.preventDefault()
        $(this).hide()
        answer_id = $(this).data('answerId')
        $('form#edit-answer-' + answer_id).show()
    clean($(this))
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').html("<div class='alert alert-danger'>" + value + "</div>")

  $('form.edit_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $(this).hide()
    $.when($('#answer_'+ answer.id).find("p:first-child").html(answer.body))
     .done ->
      $('.edit-answer-link').click   (e) ->
        e.preventDefault()
        $(this).hide()
        answer_id = $(this).data('answerId')
        $('form#edit-answer-' + answer_id).show()
    $('.edit-answer-link').show()
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').html("<div class='alert alert-danger'>" + value + "</div>")
  
  generate_answer = (answer) ->
    answer_template = _.template window.answer
    attachment_template = _.template window.attachment

    if answer.attachments
      attachments_html = ''
      $.each answer.attachments, (key, value) ->
        value['name'] = value.file.url.split('/').pop()
        attachments_html += attachment_template(value)

    full_answer = $(answer_template(answer))
    full_answer.find('.attachments').html(attachments_html)
    full_answer

  clean = ($form) ->
    # $('.new_answer').find('#answer_body').val('')
    $form.find('textarea').val('')
    $form.find('.answer-errors').html('')
    $form.find('input:file').each ->
      $(this).remove() unless $(this).attr('id')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)