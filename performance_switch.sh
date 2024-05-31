#!/bin/bash

# This script is used to switch between the available performance profiles on the Samsung Galaxy Book
# Check samsung-galaxybook-kernel-module/install.sh for the installation of the samsung-galaxybook kernel module
# The module is available at https://github.com/joshuagrisham/samsung-galaxybook-extras

str_available_profiles="$(cat /sys/firmware/acpi/platform_profile_choices)"
available_profiles=( $str_available_profiles )
current_profile="$(cat /sys/firmware/acpi/platform_profile)"
available_profiles_len=( ${#available_profiles[@]} )

for (( i = 0; i < ${available_profiles_len}; i++));
do
	if [[ ${available_profiles[$i]} == $current_profile ]]; then
		if [[ $(($i + 1)) == $available_profiles_len ]]; then
			echo ${available_profiles[0]} | sudo tee /sys/firmware/acpi/platform_profile
			dunstify "Profile : ${available_profiles[0]}"
		else
			echo ${available_profiles[$(($i + 1))]} | sudo tee /sys/firmware/acpi/platform_profile
			dunstify "Profile : ${available_profiles[$(($i + 1))]}"
		fi
	fi
done
