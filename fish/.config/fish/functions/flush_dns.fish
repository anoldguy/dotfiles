function flush_dns
    if is_mac
        sudo killall -HUP mDNSResponder
    end
end
