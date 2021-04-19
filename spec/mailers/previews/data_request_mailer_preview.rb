# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/welcome_mailer
class DataRequestMailerPreview < ActionMailer::Preview
  def data_request_email
    data_reporter = DataReporter.find(2)
    
    DataRequestMailer.with(
      data_reporter: data_reporter,
      data_request: DataRequest.where(recipient_id: data_reporter.id)
    ).data_request_email
  end
end
