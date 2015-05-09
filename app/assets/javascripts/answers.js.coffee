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

$(document).on 'ajax:success', '.vote_link', (e, data, status, xhr) ->
  total = xhr.responseJSON.total
  resource = xhr.responseJSON.resource
  if xhr.responseJSON.class == "Answer"
    $("#answer_" + resource.id + " .total_votes").text("Rating: " + total)
    vote = $("#answer_" + resource.id + " .vote")
    vote.empty()
    html_source = '<p><a class="delete_vote_link" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + resource.id + '/delete_vote">-</a></p>'
  if xhr.responseJSON.class == "Question"
    $(".total_votes").text("Rating: " + total)
    vote = $(".vote")
    vote.empty()
    html_source = '<p><a class="delete_vote_link" data-remote="true" rel="nofollow" data-method="delete" href="/questions/' + resource.id + '/delete_vote">-</a></p>'
  vote.html(html_source)

$(document).on 'ajax:success', '.delete_vote_link', (e, data, status, xhr) ->
  total = xhr.responseJSON.total
  resource = xhr.responseJSON.resource
  if xhr.responseJSON.class == "Answer"
    $("#answer_" + resource.id + " .total_votes").text("Rating: " + total)
    vote = $("#answer_" + resource.id + " .vote")
    vote.empty()
    html_source_like = '<p><a class="vote_link" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + resource.id + '/create_vote?value=1">+</a><p>'
    html_source_dislike = '<p><a class="vote_link" data-remote="true" rel="nofollow" data-method="post" href="/answers/' + resource.id + '/create_vote?value=-1">-</a><p>'
  if xhr.responseJSON.class == "Question"
    $(".total_votes").text("Rating: " + total)
    vote = $(".vote")
    vote.empty()
    html_source_like = '<p><a class="vote_link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.id + '/create_vote?value=1">+</a><p>'
    html_source_dislike = '<p><a class="vote_link" data-remote="true" rel="nofollow" data-method="post" href="/questions/' + resource.id + '/create_vote?value=-1">-</a><p>'
  vote.html(html_source_like + html_source_dislike)

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