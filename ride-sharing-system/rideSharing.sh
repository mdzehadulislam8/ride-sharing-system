#!/bin/bash

# File paths
USERS_FILE="userInformation.txt"
RIDERS_FILE="riderInformation.txt"
LOCATIONS_FILE="location.txt"

ADMIN_FILE="admin.txt"
RIDING_INFO_FILE="ridingInformation.txt"
RIDE_REQUEST="rideRequest.txt"

# Rider Account creating function
create_rider_account() {
    while true; do
        clear
        echo "Creating a new rider account..."
        
        read -p "Enter rider's name: " name
        read -p "Enter rider's contact number: " contact_number
        read -p "Enter rider's NID number: " nid_number
        read -p "Enter rider's Gender: " gender
        read -p "Enter rider's password: " password
        
        rider_id=$(generate_unique_id)
        echo "$rider_id $password $name $contact_number $nid_number $gender" >> "$RIDERS_FILE"
        echo "Rider account created successfully. Rider ID: $rider_id"

        read -p "Do you want to create another rider account? (y/n): " createAnother
        if [[ "$createAnother" != "yes" && "$createAnother" != "y" ]]; then
            break
        fi
    done
}

# Function to generate a unique ID
generate_unique_id() {
    echo "$(date +%s)"
}

# Function to delete a rider's account
delete_rider_account() {
    echo "Deleting a rider account..."
    read -p "Enter rider's ID to delete: " riderId

    temp_file=$(mktemp)

    if grep -q "^$riderId " "$RIDERS_FILE"; then
        grep -v "^$riderId " "$RIDERS_FILE" > "$temp_file"
        mv "$temp_file" "$RIDERS_FILE"
        echo "Rider account with ID $riderId deleted successfully."
    else
        echo "Rider account with ID $riderId not found."
    fi

    sleep 3
}

# Function to display all rider details
show_all_riders() {
    echo "Showing all rider details..."
    echo "---------------------------------"
    echo "Rider ID  | Password | Name | Contact Number | NID Number | Gender  | Status"
    echo "---------------------------------"

    # Iterate over each line of the file and output it to the terminal
    while read -r line; do
        echo "$line"
    done < "$RIDERS_FILE"


    echo "---------------------------------"
    
}

# Function for creating user account
create_user_account() {
    echo "Creating a new user account..."
    read -p "Enter user's username: " username

    if grep -q "^$username " "$USERS_FILE"; then
        echo "Username '$username' already exists. Please choose another username."
        return 1
    fi

    read -p "Enter user's password: " password
    read -p "Enter user's name: " name
    read -p "Enter user's contact number: " contact_number
    read -p "Enter user's NID: " nid

    user_id=$(generate_unique_id)

    echo "$user_id $username $password $name $contact_number $nid" >> "$USERS_FILE"
    echo "User account created successfully. User ID: $user_id"
    
    sleep 3
}

# Function for delete user account
delete_user_account() {
    echo "Deleting a user account..."
    read -p "Enter user's ID to delete: " userId

    temp_file=$(mktemp)

    if grep -q "^$userId " "$USERS_FILE"; then
        grep -v "^$userId " "$USERS_FILE" > "$temp_file"
        mv "$temp_file" "$USERS_FILE"
        echo "User account with ID $userId deleted successfully."
    else
        echo "User account with ID $userId not found."
    fi
}

# Function for display all user
show_all_users() {
    echo "Showing all user details..."
    echo "---------------------------------"
    echo "User ID | Username | Password |  Name       | Contact Number | NID"
    echo "---------------------------------"

    # Read and output each line from USERS_FILE
    while read -r line; do
        echo "$line"
    done < "$USERS_FILE"

    echo "---------------------------------"
}

# Function for add location
add_new_location() {
    echo "Adding a new location..."
    read -p "Enter source location: " source_location
    read -p "Enter destination location: " destination_location
    read -p "Enter distance (in Km) between $source_location and $destination_location: " distance

    # Append location details to the locations file
    echo "$source_location $destination_location $distance" >> "$LOCATIONS_FILE"
    echo "Location added successfully."
}

# Function for delete location
delete_location() {
    echo "Deleting a location..."
    read -p "Enter source location: " source_location
    read -p "Enter destination location: " destination_location

    temp_file=$(mktemp)

    if grep -q "^$source_location $destination_location " "$LOCATIONS_FILE"; then
        grep -v "^$source_location $destination_location " "$LOCATIONS_FILE" > "$temp_file"
        mv "$temp_file" "$LOCATIONS_FILE"
        echo "Location with source '$source_location' and destination '$destination_location' deleted successfully."
    else
        echo "Location with source '$source_location' and destination '$destination_location' not found."
    fi
}

# Function for display all location
display_all_locations() {
    echo "Displaying all locations and their distances..."
    echo "-----------------------------------------------"
    echo "Source Location | Destination Location | Distance (Km)"
    echo "-----------------------------------------------"

    while read -r line; do
        source_location=$(echo "$line" | awk '{print $1}')
        destination_location=$(echo "$line" | awk '{print $2}')
        distance=$(echo "$line" | awk '{print $3}')
        
        echo "$source_location | $destination_location | $distance"
    done < "$LOCATIONS_FILE"

    echo "-----------------------------------------------"
}

# Function for individual user details
user_profile() {
    clear
    local search_username="$1"

    while read -r line; do
        stored_username=$(echo "$line" | awk '{print $2}')

        if [ "$search_username" = "$stored_username" ]; then
            password=$(echo "$line" | awk '{print $3}')
            full_name=$(echo "$line" | awk '{print $4}')
            contact=$(echo "$line" | awk '{print $5}')
            nid=$(echo "$line" | awk '{print $6}')
            echo ""
            echo "Username: $search_username"
            echo "Password: $password"
            echo "Full Name: $full_name"
            echo "Contact number: $contact"
            echo "NID: $nid"
            echo ""
            return 0 
        fi
    done < "$USERS_FILE"

    echo "User with username '$search_username' not found."
    return 1
}

# Function to read input from file and construct graph
read_input() {
    declare -gA graph 

    while read -r line || [ -n "$line" ]; do
        local parts=($line)
        local source=${parts[0]}
        local destination=${parts[1]}
        local distance=${parts[2]}
        graph["$source"]+=" $destination:$distance"
        graph["$destination"]+=" $source:$distance"
    done < "$LOCATIONS_FILE"
}

# Function to implement Dijkstra's algorithm
dijkstra() {
    local source="$1"
    local destination="$2"
    declare -A distances  # Declare associative array to store distances
    declare -A visited    # Declare associative array to store visited nodes

    # Initialize distances to infinity
    for node in "${!graph[@]}"; do
        distances["$node"]=999999
    done

    distances["$source"]=0

    # Dijkstra's algorithm
    while true; do
        local current=""
        local min_distance=999999
        for node in "${!distances[@]}"; do
            local distance=${distances["$node"]}
            if [[ ! ${visited["$node"]} ]] && ((distance < min_distance)); then
                current="$node"
                min_distance="$distance"
            fi
        done

        if [[ -z "$current" || "$current" == "$destination" ]]; then
            break
        fi

        visited["$current"]=1

        # Update distances
        for neighbor_info in ${graph["$current"]}; do
            local neighbor=$(echo "$neighbor_info" | cut -d ':' -f 1)
            local weight=$(echo "$neighbor_info" | cut -d ':' -f 2)
            local new_distance=$((distances["$current"] + weight))
            if ((new_distance < distances["$neighbor"])); then
                distances["$neighbor"]=$new_distance
            fi
        done
    done

    # Output shortest distance
    echo "${distances["$destination"]}"
}

# Function to calculate fare based on distance
calculate_fare() {
    distance="$1"
    fare=$((distance * 3))  # Assuming fare is 3 TK per KM
    echo "$fare"
}

# Function to search for a ride
search_for_ride() {
    # Prompt the user to enter source and destination
    username="$1"
    read -p "Enter source location: " source_location
    read -p "Enter destination location: " destination_location
    read_input
    distance=$(dijkstra "$source_location" "$destination_location")

    if [ -z "$distance" ]; then
        echo "Error: Unable to find a route between $source_location and $destination_location."
        return
    fi

    # Calculate fare based on distance
    fare=$(calculate_fare "$distance")

    # Print ride information
    echo "Ride information:"
    echo "Source: $source_location"
    echo "Destination: $destination_location"
    echo "Distance: $distance KM"
    echo "Fare: $fare TK"

    # Store ride information in riding request file
    echo "$username $source_location $destination_location $distance $fare" >> "$RIDE_REQUEST"
    echo "Wait for rider confirmation or you can cancel this ride before confirmation"
}

#Function for ride request
ride_requests() {
    clear
    rider_username="$1"
    rider_id="$2"
    echo "Showing all ride requests:"
    echo "----------------------------------------"
    echo "No. | Username | Source | Destination | Distance (Km) | Fare (Tk)"
    echo "----------------------------------------"

    index=1
    while read -r line; do
        echo "$index. $line"
        ((index++))
    done < "$RIDE_REQUEST"
    echo "----------------------------------------"

    read -p "Enter the number of the ride request you want to accept: " choice
    chosen_request=$(sed "${choice}q;d" "$RIDE_REQUEST")
    if [ -z "$chosen_request" ]; then
        echo "Invalid choice. Please try again."
        return
    fi

    # Parse the chosen request
    username=$(echo "$chosen_request" | awk '{print $1}')
    source=$(echo "$chosen_request" | awk '{print $2}')
    destination=$(echo "$chosen_request" | awk '{print $3}')
    distance=$(echo "$chosen_request" | awk '{print $4}')
    fare=$(echo "$chosen_request" | awk '{print $5}')

   
    # Store the chosen ride information in the RIDING_INFO_FILE
    echo "$username $source $destination $rider_username $destination $fare" >> "$RIDING_INFO_FILE"
    echo "Ride request accepted and recorded successfully."

    # Remove the chosen request from RIDE_REQUEST file
    sed -i "${choice}d" "$RIDE_REQUEST"
}

# Function to check all riding history
check_all_riding_history() {
    clear
    echo "Showing all riding history:"
    echo "----------------------------------------"
    echo "Username | Source | Destination | Rider Name | Fare (Tk)"
    echo "----------------------------------------"

    while read -r line; do
        echo "$line"
    done < "$RIDING_INFO_FILE"
    echo "----------------------------------------"
}

# Function to check ride history for a specific user
check_user_ride_history() {
    clear
    username="$1"
    echo "Showing ride history for user: $username"
    echo "----------------------------------------"
    echo "Source | Destination | Rider Name | Fare (Tk)"
    echo "----------------------------------------"

    grep "^$username " "$RIDING_INFO_FILE" | while read -r line; do
        source=$(echo "$line" | awk '{print $2}')
        destination=$(echo "$line" | awk '{print $3}')
        rider_id=$(echo "$line" | awk '{print $4}')
        rider_name=$(echo "$line" | awk '{print $5}')
        fare=$(echo "$line" | awk '{print $6}')
        echo "$source | $destination | $rider_id | $rider_name | $fare"
    done

    echo "----------------------------------------"
}

# Function to cancel a ride request for a specific user
cancel_ride_request() {
    clear
    username="$1"
    echo "Searching for ride requests for user: $username"
    echo "----------------------------------------"

    found_requests=$(grep -n "^$username " "$RIDE_REQUEST")
    if [ -z "$found_requests" ]; then
        echo "No ride requests found for user: $username"
        return
    fi

    echo "Ride requests for user: $username"
    echo "$found_requests"
    echo "----------------------------------------"

    read -p "Enter the number of the ride request you want to cancel: " choice
    line_number=$(echo "$found_requests" | sed -n "${choice}p" | cut -d: -f1)
    if [ -z "$line_number" ]; then
        echo "Invalid choice. Please try again."
        return
    fi

    # Remove the chosen request from RIDE_REQUEST file
    sed -i "${line_number}d" "$RIDE_REQUEST"
    echo "Ride request canceled successfully."
}

# Main script

while true; do
    echo "1. Admin"
    echo "2. User"
    echo "3. Rider"
    echo "4. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1)  
            clear
            read -p "Enter username: " username
            read -s -p "Enter password: " password
            echo

            if grep -q "^$username $password$" "$ADMIN_FILE"; then
                echo "Login successful. Welcome, $username!"
                while true; do
                    echo "1. Check All Riding History"
                    echo "2. Create Rider Account"
                    echo "3. Delete Rider Account"
                    echo "4. Check Rider Details"
                    echo "5. Create User Account"
                    echo "6. Delete User Account"
                    echo "7. Check User Details"
                    echo "8. Add new Location"
                    echo "9. Delete a Location"
                    echo "10. Check all Location"
                    echo "11. Logout"
                  
                    read -p "Enter your choice: " adminChoice
                  
                    case $adminChoice in
                    	1)
                    		clear
                    		check_all_riding_history
                    		;;
                        2)
                            clear
                            create_rider_account
                            ;;
                        3)
                            clear
                            delete_rider_account
                            ;;
                        4)
                            clear
                            show_all_riders
                            ;;
                        5)
                            clear
                            create_user_account
                            ;;
                        6)
                            clear
                            delete_user_account
                            ;;
                        7)
                            clear
                            show_all_users
                            ;;
                        8)
                            clear
                            add_new_location
                            ;;
                        9)
                            clear
                            delete_location
                            ;;
                        10)
                            clear
                            display_all_locations
                            ;;
                        11)
                            clear
                            read -p "Do you want to logout? (y/n): " logoutChoice
                            if [[ "$logoutChoice" == "y" || "$logoutChoice" == "Y" ]]; then
                                break
                            fi
                            ;;
                        *)
                            clear
                            echo "Invalid choice!"
                            ;;
                    esac
                done
            else
                echo "Invalid username or password."
            fi
            ;;
        2)
            clear
            while true; do
                echo "1. Create Account"
                echo "2. Login"
                echo "3. exit"
                read -p "Enter your choice :" userChoice
                
                case $userChoice in
                    1) 
                        clear
                        create_user_account
                        ;;
                    2)  
                        clear
                        read -p "Enter username: " username
                        read -s -p "Enter password: " password
                        echo
                        flag=0

                        while read -r line; do
                            stored_username=$(echo "$line" | awk '{print $2}')
                            stored_password=$(echo "$line" | awk '{print $3}')

                            if [[ "$username" == "$stored_username" && "$password" == "$stored_password" ]]; then
                                ((flag++))
                                break      
                            fi
                        done < "$USERS_FILE"

                        if [[ "$flag" -gt 0 ]]; then
                            clear
                            echo "Welcome back! $stored_username"
                            echo ""
                            while true; do
                                echo "1. Check profile"
                                echo "2. Check Ride history"
                                echo "3. Search for a ride"
                                echo "4. Cancel ride"
                                read -p "Enter your choice: " userSecondChoice
                                case $userSecondChoice in
                                    1)
                                        user_profile "$stored_username"
                                        ;;
                                    2)
                                    	check_user_ride_history "$stored_username"
                                    	;;
                                    3)
                                        search_for_ride "$stored_username"
                                        ;;
                                    4)
                                    	cancel_ride_request "$stored_username"
                                    	;;
                                    *)  
                                        echo "Invalid Choice"
                                        ;;
                                esac
                            done
                        else
                            echo "Invalid username or password."
                        fi
                        ;;
                    3)
                    	    
                        echo "Exiting program."
                        exit 0
                        ;;
                    *)
                        echo "Invalid choice!"
                        ;; 
                esac
            done
            ;;
        3)
        	clear
        	read -p "Enter username: " username
            read -s -p "Enter password: " password
            echo
            flag=0

            while read -r line; do
                stored_username=$(echo "$line" | awk '{print $3}')
                stored_password=$(echo "$line" | awk '{print $2}')

                if [[ "$username" == "$stored_username" && "$password" == "$stored_password" ]]; then
                    ((flag++))
                    break      
                fi
            done < "$RIDERS_FILE"

            if [[ "$flag" -gt 0 ]]; then
                clear
                echo "Welcome back rider! $stored_username"
                echo ""
                while true; do
					echo "1. Ride Requests"
					echo "2. Logout"
					read -p "Enter your choice: " mainChoice

					case $mainChoice in
						1)
								ride_requests "$stored_username"
							
							;;
						2)
							clear
                            read -p "Do you want to logout? (y/n): " logoutChoice
                            if [[ "$logoutChoice" == "y" || "$logoutChoice" == "Y" ]]; then
                                break
                            fi

							;;
						*)
							echo "Invalid choice! Please try again."
							;;
					esac
				done
            else 
            	echo "Invalid username or password"
            fi
            ;;
                        
        *)
            echo "Invalid choice!"
            ;;
    esac
done

