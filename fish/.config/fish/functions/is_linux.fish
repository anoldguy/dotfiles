function is_linux
    test (uname) = Linux && return 0 || return 1
end
