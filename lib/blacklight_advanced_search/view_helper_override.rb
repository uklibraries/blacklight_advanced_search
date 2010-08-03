# Meant to be applied on top of Blacklight view helpers, to over-ride
# certain methods from RenderConstraintsHelper (newish in BL), 
# to effect constraints rendering and search history rendering, 
module BlacklightAdvancedSearch::ViewHelperOverride

  #Over-ride of Blacklight method, provide advanced constraints if needed,
  # otherwise call super. Existence of an @advanced_query instance variable
  # is our trigger that we're in advanced mode. 
  def render_constraints_query(my_params = params)
    if (@advanced_query.nil?)
      return super(my_params)
    else
      content = ""
      @advanced_query.keyword_queries.each_pair do |field, query|
        label = field.to_s.capitalize
        content << render_constraint_element(
          label, query,
          :remove =>
            catalog_index_path(remove_advanced_keyword_query(field,my_params))
        )
      end
      return content
    end
  end

  #Over-ride of Blacklight method, provide advanced constraints if needed,
  # otherwise call super. Existence of an @advanced_query instance variable
  # is our trigger that we're in advanced mode. 
  def render_constraints_filters(my_params = params)
    content = super(my_params)

    if (@advanced_query)
      @advanced_query.filters.each_pair do |field, value_list|
        label = Blacklight.config[:facet][:labels][field] or field.to_s.capitalize
        content << render_constraint_element(label, value_list.join(" OR "))
      end
    end
    
    return content
  end


  
end
