set :output, 'log/whenever.log'
every :day, :at => '1:00am' do
  rake "send_summaries"
end