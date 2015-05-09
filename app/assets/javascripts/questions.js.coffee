# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editQuestionLink =  ($doc) ->
  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

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

$(document).ready(editQuestionLink)
$(document).on('page:load', editQuestionLink)
$(document).on('page:update', editQuestionLink)
