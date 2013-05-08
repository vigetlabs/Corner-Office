module ReadOnlyResource
  extend ActiveSupport::Concern

  class ReadOnlyError < StandardError; end

  included do
    extend(ClassMethod)

    alias_method :save,              :raise_error
    alias_method :save!,             :raise_error
    alias_method :update,            :raise_error
    alias_method :update_attributes, :raise_error
    alias_method :update_attribute,  :raise_error
    alias_method :delete,            :raise_error
    alias_method :destroy,           :raise_error

    class << self
      alias_method :create,          :raise_error
    end
  end

  module ClassMethod
    def raise_error(*)
      raise ReadOnlyError, "The #{self.name} resource is read-only."
    end
  end

  def raise_error(*)
    self.class.raise_error
  end
end
