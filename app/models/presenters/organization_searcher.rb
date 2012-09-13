class OrganizationSearcher
  include ActiveAttr::MassAssignment

  attr_accessor :kind, :category, :feature, :offer, :payment

  def searcher
    HasSearcher.searcher(kind.to_sym, search_params)
  end

  def search_params
    {}.tap do |hash|
      hash["#{kind}_category"] = category unless category.nil?
      hash["#{kind}_feature"] = feature unless feature.nil?
      hash["#{kind}_offer"] = offer unless offer.nil?
      hash["#{kind}_payment"] = payment unless payment.nil?
    end
  end

  def features
    searcher.facet("#{kind}_feature").rows.map(&:value)
  end

  def offers
    searcher.facet("#{kind}_offer").rows.map(&:value)
  end

  def payments
    searcher.facet("#{kind}_payment").rows.map(&:value)
  end
end
