module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    page = params[:page]
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}-#{page}"
  end
end
