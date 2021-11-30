#!/bin/bash

allowed_platforms=("freddy","qtrobot")
allowed_cmds=("enable","restart","disable")
platform=$1
cmd=$2

if [[ -z "$platform" ]] || [[ ${allowed_platforms[*]} != $platform ]]; then
    echo "Manages all service files for a specified platform"
    echo "Usage: ./manage_services.bash [platform] [cmd]"
    echo "       where the allowed values for platform are [$allowed_platforms]"
    echo "       and the allowed values for cmd are [$allowed_cmds]"
    exit 1
else
    if [ $cmd == "enable" ]; then
        echo 'Copying service files to /etc/systemd/system...';
        sudo cp $platform/* /etc/systemd/system/
        echo 'Service files copied successfully';

        echo 'Enabling services...';
        service_files=$(ls $platform);
        for service in $service_files; do
            echo 'Enabling' $service;
            sudo systemctl enable $service
        done
        echo 'Services enabled successfully';
    elif [ $cmd == "restart" ]; then
        echo 'Restarting services...';
        service_files=$(ls $platform);
        for service in $service_files; do
            echo 'Restarting' $service;
            sudo systemctl restart $service
        done
        echo 'All services have been restarted';
    elif [ $cmd == "disable" ]; then
        echo 'Disabling services...';
        service_files=$(ls $platform);
        for service in $service_files; do
            echo 'Disabling' $service;
            sudo systemctl disable $service

            echo 'Removing' $service 'from /etc/systemd/system';
            sudo rm /etc/systemd/system/$service
        done
        echo 'Services disabled';
    else
        echo "Unknown command $cmd"
    fi
fi
