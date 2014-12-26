class AccountsController < ApplicationController
  def new
    timezones_file = File.open("lib/assets/timezones.txt").read.split("\n")
    @timezones = timezones_file.map{|x| {:name => x.split("=>")[0], :id => x.split(":")[1]}}
  end

  def create

  end
end
