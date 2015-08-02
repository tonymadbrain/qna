module PagesHelper
  def markdown(source)
    Kramdown::Document.new(source, {coderay_css: :class, coderay_line_numbers: nil}).to_html.html_safe
  end
end
