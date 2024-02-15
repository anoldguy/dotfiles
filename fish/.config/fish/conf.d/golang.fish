# Gate golang stuff on presence of go
fish_add_path ~/go/bin
if status --is-interactive; and which go > /dev/null
    
end
