require "carrier-pigeon"

namespace :irc do
  desc "Announce deploy to irc"
  task :announce_deploy do
    CarrierPigeon.send(
      :uri => irc_uri,
      :message => "#{ENV['USER'].capitalize} is deploying #{application_name || application} to #{server}",
      :ssl => irc_ssl
    )
  end

  task :announce_seed do
    CarrierPigeon.send(
      :uri => irc_uri,
      :message => "#{ENV['USER'].capitalize} is seeding the database for #{application_name || application} #{server}",
      :ssl => irc_ssl
    )
  end
end