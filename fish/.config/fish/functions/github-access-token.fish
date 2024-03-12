function github-access-token
    if is_linux
        echo not-set
    else
        # Maybe someday, the 1Password CLI won't suck, and
        # I can pull this out of one spot.
        security find-internet-password -s github.com -w
    end
end
