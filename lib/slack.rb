#!/usr/bin/env ruby
require_relative "user"
require_relative "channel"
require_relative 'workspace'
require 'dotenv'
Dotenv.load
# require_relative "channel"

def main
  workspace = Slack::Workspace.new
  user_choice = nil
  
  until user_choice == "3"
    puts "\nWelcome to the Ada Slack CLI! Put quit to exit the program"
    
    # user can list users, chanels, or quit
    user_choice = prompt(
      "\nWhat would you like to do?",
      ["List users", "List channels", "Quit"]
    )
    
    # path for list users
    if user_choice == "1"
      list = Slack::User.list
      print_user_list(list)
      
      search_choice = prompt(
        "\nDo you want to find a user by:", 
        ["Slack id", "User name"]
      )
      
      # user decides how they want to look up recipient
      if search_choice == "1"
        puts "\nPlease enter that person's slack id: "
        slack_id = validate(gets.chomp)
        workspace.select_user_slack_id(slack_id: slack_id)
      elsif search_choice == "2"
        puts "\nPlease enter the person's user name:"
        user_name = validate(gets.chomp)
        response = workspace.select_user_username(user_name: user_name)
        while response.nil? 
          puts "Couldn't find user :("
          print "Please make a valid selection: > "
          user_name = validate(gets.chomp)
          response = workspace.select_user_username(user_name: user_name)
        end
      end
      
      # prompts the user after recipient has been selected
      # built in helper methods to validate inputs
      communication_choice = prompt(
        "Do you want to:",
        ["See this user's details", "Send them a message"]
      )
      
      # sends messages or shows details for selected client
      if communication_choice == "1"
        puts "\n---DETAILS---"
        workspace.show_details
      elsif communication_choice == "2"
        puts "Please enter a message: "
        message = gets.chomp
        workspace.send_message(message)
      end
      
      # path for lists channels
    elsif  user_choice == "2"
      list = Slack::Channel.list
      print_channel_list(list)
      
      search_choice = prompt(
        "\nDo you want to find a channel by:", 
        ["Slack id", "Channel name"]
      )
      
      # user decides how to look up channel
      if search_choice == "1"
        print "\nPlease enter that channel's slack id: > "
        slack_id = validate(gets.chomp)
        workspace.select_channel_slack_id(slack_id: slack_id)
      elsif search_choice == "2"
        print "\nPlease enter the name of that channel: > "
        user_name = validate(gets.chomp)
        workspace.select_channel_username(user_name: user_name)
      end
      
      # prompts user for selection
      # built in validate methods with helper methods
      communication_choice = prompt(
        "Do you want to:",
        ["See this channel's details", "Send a message to the channel?"]
      )
      
      if communication_choice == "1"
        puts "\n---DETAILS---"
        workspace.show_details
      elsif communication_choice == "2"
        "\nPlease enter a message: > "
        message = gets.chomp
        workspace.send_message(message)
      end
      
      
      puts "Thank you for using the Ada Slack CLI"
    end
  end
  exit 
end

def prompt(message, options)
  puts
  puts message
  options.each_with_index do |option, index|
    puts "#{index + 1}. #{option}"
  end
  input = gets.chomp
  
  until input.to_i <= options.length && input.to_i > 0
    print "Invalid selection. > "
    input = gets.chomp
  end
  return input
end

def print_user_list(list)
  list.each do |member_object|
    puts
    puts "slack id: #{member_object.slack_id}"
    puts "name: #{member_object.name}"
    puts "real name: #{member_object.real_name}\n"
  end
end

def print_channel_list(list)
  list.each do |member_object|
    puts
    puts "slack id: #{member_object.slack_id}"
    puts "name: #{member_object.name}"
    puts "topic: #{member_object.topic}"
    puts "member_count: #{member_object.members}"
  end
end

def validate(input)
  while input.empty? || input.nil?
    print "please make a valid selection: >"
    input = gets.chomp
  end
  return input
end

main



main if __FILE__ == $SLACK