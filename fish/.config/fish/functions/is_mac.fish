function is_mac
    test (uname) = Darwin && return 0 || return 1
end
