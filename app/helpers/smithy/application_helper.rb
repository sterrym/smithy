module Smithy
  module ApplicationHelper
    def smithy_link_to_add_fields(name, association, form_builder)
      blueprint = form_builder.semantic_fields_for(association, model_object(form_builder, association), :child_index => "new_#{association}") do |builder|
        raw render("#{form_builder.object.class.to_s.tableize}/#{association.to_s.singularize}_fields", :f => builder)
      end
      form_builder.template.link_to(name, "javascript:void(0)", :class => "add_nested_fields", "data-association" => association, 'data-fields-blueprint' => CGI.escapeHTML(blueprint).html_safe)
    end

    def smithy_link_to_remove_fields(name, form_builder)
      form_builder.hidden_field(:_destroy) + @template.link_to(name, "javascript:void(0)", :class => "remove_nested_fields")
    end

    def render_markdown_input(fieldname, editor_name, form_builder)
      form_builder.input fieldname, as: 'markdown'
    end

    private
      def model_object(form_builder, association)
        model_object = form_builder.object.class.reflect_on_association(association).klass.new
      end

  end
end
