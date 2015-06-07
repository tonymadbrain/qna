class Search
  SEARCH_OPTIONS = %w(Questions Answers Comments Users)

  def self.filter(query, options = {})
    condition = options[:condition]
    safe_query = Riddle::Query.escape(query)

    if SEARCH_OPTIONS.include?(condition)
      condition.singularize.constantize.search(safe_query)
    else
      ThinkingSphinx.search safe_query
    end
  end
end