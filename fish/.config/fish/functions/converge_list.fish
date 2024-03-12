function converge_list -a list_name list_command -d "Converge a list of nodes and track progress"
    # Set default command if not provided
    set -q list_command[1] || set list_command "sleep 2 && sudo chef-client"

    touch $list_name.done
    for host in (cat $list_name)
        # We've been asked to stop, exit
        if test -e $list_name.stop
            break
        end

        # If we already processed this node, skip
        if grep -q "^$host\$" $list_name.done
            continue
        end

        # Process this node
        echo $host
        ssh $host "$list_command"
        if test $status -eq 0
            echo $host >>$list_name.done
        end
    end
end
