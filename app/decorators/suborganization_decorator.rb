class SuborganizationDecorator < ApplicationDecorator
  def decorated_organization
    OrganizationDecorator.decorate organization
  end

  delegate :logo_link, :title_link, :address_link, :html_description,
    :truncated_description, :site_link, :email_link, :stand_info,
    :to => :decorated_organization

  def decorated_title
    h.content_tag :h3, title, class: :suborganization if title?
  end

  def decorated_description
    h.content_tag(:div, description.as_html, class: :description) if description?
  end

  def list_of_characteristics(name)
    content = ""
    content << h.content_tag(:li, I18n.t("activerecord.attributes.#{self.decorate.model.class.name.downcase}.#{name.singularize}"), class: "title")
    content << "\n"
    organization_class = self.decorate.model.class == Billiard ? 'entertainments' : self.decorate.model.class.name.downcase.pluralize
    self.send(name).each do |value|
      content << h.content_tag(:li, h.link_to(value, h.organizations_path(organization_class: organization_class,
                                                                          category: priority_category,
                                                                          query: "#{name}/#{value.mb_chars.downcase}")))
      content << "\n"
    end
    h.content_tag(:ul, content.html_safe)
  end

  def characteristics_by_type(types)
    result = types.split.map { |characteristic| list_of_characteristics(characteristic) if self.send(characteristic).any? }.join("\n")
    h.content_tag :div, result.html_safe, class: "characteristics" unless result.blank?
  end

  def priority_category
    categories.first.mb_chars.downcase
  end

  def htmlize_text(text)
    text.blank? ? "" : text.as_html
  end

end
