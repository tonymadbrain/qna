window.answer = '''
  <div id="answer_<%= id %>">
    <% if ( best ) { %>
      <p> This is best answer</p>
    <% } %>
    <p> <%= body %> </p>
    <p> Attachments: </p>
    <ul class="attachments">
    </ul>
    <a class="edit-answer-link btn btn-primary btn-xs" data-answer-id="<%= id %>" href="">Edit</a>
    <a class="btn btn-danger btn-xs" data-remote="true" rel="nofollow" data-method="delete" href="/answers/<%= id %>">Delete answer</a>
    <form id="edit-answer-<%= id %>" role="form" class="edit_answer" action="/answers/<%= id %>" accept-charset="UTF-8" data-remote="true" method="post">
      <input name="utf8" value="✓" type="hidden"><input name="_method" value="patch" type="hidden">
      <div class="form-group">
        <label class="control-label required" for="answer_body">Edit answer</label>
        <textarea class="form-control" name="answer[body]" id="answer_body"><%= body %></textarea>
      </div>
      <input name="commit" value="Save" class="btn btn-default" type="submit">
    </form>  
  </div>
'''
window.attachment = '''
  <div id="attachment_<%= id %>">
    <li>
      <a href="<%= file.url %>"><%= name %></a>
      <a data-remote="true" rel="nofollow" data-method="delete" href="/attachments/<%= id %>">Delete file</a>
    </li>
  </div>
'''
