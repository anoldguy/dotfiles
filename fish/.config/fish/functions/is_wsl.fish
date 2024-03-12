function is_wsl
    if is_linux; and test -d /mnt/c
        return 0
    else
        return 1
    end
end
