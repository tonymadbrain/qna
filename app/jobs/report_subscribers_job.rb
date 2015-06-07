class ReportSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |subscriber|
      ReportMailer.delay.report(subscriber, answer)
    end
  end
end
