# frozen_string_literal: true

module AccountsHelper
  # Returns the Gravatar (http://gravatar.com/) for the given account.
  def gravatar_for(account, size: 50, css_class: :gravatar)
    gravatar_id = Digest::MD5.hexdigest(account.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: account.name, class: css_class)
  end
end
