$(document).on 'click', '.create-comment-link', (e) ->
  e.preventDefault();
  $(this).hide();
  resourceId = $(this).data('resourceId')
  resourceType = $(this).data('resourceType')
  $("form#comment-for-#{resourceType}-#{resourceId}").show()