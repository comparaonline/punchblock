# encoding: utf-8

module KeyValuePairNode
  ##
  # @param [String] name
  # @param [String] value
  #
  def initialize(name, value = '')
    super()
    case name
    when Nokogiri::XML::Node
      inherit name
    else
      self.name = name
      self.value = value
    end
  end

  # The Header's name
  # @return [Symbol]
  def name
    read_attr :name
  end

  # Set the Header's name
  # @param [Symbol] name the new name for the param
  def name=(name)
    write_attr :name, name
  end

  # The Header's value
  # @return [String]
  def value
    read_attr :value
  end

  # Set the Header's value
  # @param [String] value the new value for the param
  def value=(value)
    write_attr :value, value
  end

  def inspect_attributes # :nodoc:
    [:name, :value] + super
  end
end
