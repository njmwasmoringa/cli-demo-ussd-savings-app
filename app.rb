require 'pry'
require './app-menu.rb'

$users = [];
$current_user;
$session = []; # stack: last in last out [] -> []

# verify_pin method
# @param fields: is a hash containing pin and verified_pin keys
# @param step: is for registering at which step of the menu we are in
# @return the next steps if verification fails or passes
def verify_pin fields, step

    is_correct = fields["pin"] == fields["verified_pin"];

    puts ""
    puts "Invalid pin" unless is_correct
    puts ""

    #return the next index of where to go next
    is_correct ? step + 1 : 2
    
end

# deposit method
# @param fields: is a hash containing the amount to deposit as key
# @return return nil
def deposit fields
    #check if there is a user signed in
    if $current_user
        savings = $current_user[:savings] ? $current_user[:savings] : 0
        $current_user[:savings] = savings + fields["amount"].to_i
        puts fields["amount"].to_s + " deposited, your new balance is " + $current_user[:savings].to_s
        $current_user[:statement] << "Deposit: " + fields["amount"]
        $session = []
        puts ""
    end
end

def check_balance fields
    if $current_user
        puts "Your balance is " + ($current_user[:savings] || 0).to_s
    end
    $session = []
    puts ""
end

def sign_up fields
    user = { savings:0, statement:[] }

    pp user.merge(fields)

    $users << user.merge(fields)

    puts "Hello "+fields["name"]+"! you have successfully signed up";
    puts ""
    $session = [];
end

def sign_in fields, step
    $current_user = $users.find{ |user| user["phone"] == fields["phone"] && user["pin"] == fields["pin"] }
    if $current_user
        step + 1
    else
        puts "Invalid phone or pin"
        step - 1
    end
end

def show_instructions instructions, options=nil

     #Check if there are any instructions and display them
     if instructions.class == String
        puts instructions
    elsif instructions.class == Array
        instructions.map{ |instruction| puts instruction }
    end

    if options
        options.each do |key, value|
            puts [key, ": ", value[:name]].join("")
        end

        if $session.length > 0
            puts "0: Previous Menu" unless $session.length >= 1
            puts "00: Main Menu"
        end

        selected_option = gets.chomp
        $session << selected_option.to_i unless interuptions(selected_option)
        
        puts ""
    end

end

def interuptions user_input
    is_interupted = if user_input == "00"
        $session = []
        true
    elsif user_input == "0"
        $session.pop
        true
    else
        false
    end
end

def statement fields
    if $current_user
        pp $current_user[:statement]
    end
end

def app

    # get the current selection in the session
    selection = $session[0]

    if selection && $menus[selection]

        if !$menus[selection].key?(:options)
        
            current_menu = $menus[selection]

            #Check if there are any instructions and display them
            show_instructions(current_menu[:instructions])

            #check if there are any input requests
            if current_menu[:requests]
                fields = {}
                request_index = 0;
                while request_index <  current_menu[:requests].length
                    # define the request
                    request = current_menu[:requests][request_index]
                    #Tell what the user should do
                    puts request[:request];
                    #Request the user input
                    user_input = gets.chomp

                    if user_input == "0"
                        request_index = current_menu[:requests].length;
                        $session.pop
                        break
                    elsif user_input == "00"
                        $session = []
                        break
                    end

                    fields[request[:field]] = user_input
                    #Check if there is something that needs to be done after the input i.e. validations
                    if  request[:action]
                        request_index = send(request[:action], fields, request_index)
                    else
                        request_index = request_index + 1;
                    end
                end

                if current_menu[:action]
                    send(current_menu[:action], fields);
                end

            end
        
        else
            current_menu = $menus[selection];

            #Check if there are any instructions and display them
            show_instructions(current_menu[:instructions], current_menu[:options])
        end
        
    #Else welcome the user
    else
        show_instructions([
            "Hello and welcome to the savings app.",
            "Select one of the options below to proceed"
        ], $menus)

    end
    
end

while true
    app
end
