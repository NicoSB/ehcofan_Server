namespace :export do
  desc "Prints Country.all in a seeds.rb way."
  task :seeds_format => :environment do
    Player.order(:id).all.each do |player|
   		date = "Date.new(" + player.birthdate.year.to_s + "," + player.birthdate.mon.to_s + "," + player.birthdate.mday.to_s + ")"
      puts "Player.create(#{player.serializable_hash.delete_if {|key, value| ['birthdate', 'created_at','updated_at','id'].include?(key)}.to_s.gsub(/[{}]/,'')}, \"birthdate\"=>" + date + ")"
    end
  end
end