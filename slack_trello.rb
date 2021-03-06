require 'bundler/setup'
require 'sinatra'
require 'dotenv'
Dotenv.load
require 'json'
require 'slack_trello'

class SlackTrelloApp < Sinatra::Application

  #TODO: Need to test this
  before do
    return 401 unless WHITELIST_TOKENS.include?(request["token"])
  end

  WHITELIST_TOKENS = [
    ENV["SLACK_WORK_COMMAND_TOKEN"],
    ENV["SLACK_CREATE_CARD_COMMAND_TOKEN"],
    ENV["SLACK_RETRO_COMMAND_TOKEN"]
  ].compact

  def work
    SlackTrello::WorkCommand.new(params, ENV["SLACK_WEBHOOK_URL"]).run
  end

  def create_card
    SlackTrello::CreateCardCommand.new(params, ENV["SLACK_WEBHOOK_URL"]).run
  end

  def retro
    SlackTrello::RetroCommand.new(params, ENV["SLACK_WEBHOOK_URL"]).run
  end

  post '/bug' do
    return work.to_json
  end
end

