class ContactMailer < ApplicationMailer
	def contact_us(email, body)
    mail from: email, to: ApplicationMailer.default[:from], subject: 'Contact us', body: body
  end
end
