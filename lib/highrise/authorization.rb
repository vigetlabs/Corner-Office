module Highrise
  class Authorization < Highrise::Base
    self.site = CornerOffice::HIGHRISE_CONFIG["site"]

    def self.retrieve
      find(:one, :from => '/authorization.xml')
    rescue ActiveResource::UnauthorizedAccess
      nil
    end

    def highrise_sites
      if highrise_accounts
        highrise_accounts.inject({}) do |hash, account|
          hash[account.name] = account.href
          hash
        end
      end
    end

    private

    def launchpad_accounts
      accounts.account if accounts
    end

    def highrise_accounts
      @highrise_accounts ||= product_accounts(:highrise)
    end

    def product_accounts(product)
      if launchpad_accounts
        launchpad_accounts.select { |account| account.product == product.to_s }
      end
    end
  end
end
