class OrganizationsCollection
  include ActiveAttr::MassAssignment

  attr_accessor :kind, :query

  def initialize(params)
    super(params)
  end

  def categories
    parameters['categories']
  end

  def features
    parameters['features']
  end

  def offers
    parameters['offers']
  end

  def cuisines
    parameters['cuisines']
  end

  def parameters
    Hash[Hash[query.scan(/(categories|cuisines|features|offers)?(?:\/)?((?:\w+(?:\/)?){2})(?!categories|cuisines|features|offers)?/)].map { |k,v| [k, v.split('/')]}]
  end
end
