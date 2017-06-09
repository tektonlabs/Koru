task :send_summaries => :environment do
  Refuge.all.each do |refuge|
    refuge.send_summary_email
  end
end
