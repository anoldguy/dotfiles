require 'irb/completion'
#require 'irb/ext/save-history'

IRB.conf[:PROMPT_MODE]  = :SIMPLE
IRB.conf[:AUTO_INDENT]  = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 50
IRB.conf[:BACK_TRACE_LIMIT] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path('.irb_history', ENV['HOME'])
