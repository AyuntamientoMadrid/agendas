module Features
  module SessionHelpers

    def fill_in_newsletter_form(options = {})
      fill_in "newsletter_subject", with: (options[:subject] || "This is a different subject")
      fill_in "newsletter_body", with: (options[:body] || "This is a different body")
      select options[:interest], from: "newsletter_interest_id"
    end

    def error_message(resource_model = nil)
      resource_model ||= "(.*)"
      /\d ?errors? prohibited this #{resource_model} from being saved./
    end

  end
end
