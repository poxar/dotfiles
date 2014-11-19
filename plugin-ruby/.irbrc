
#
# ~/.irbrc
# irb initialization file
#

require 'irb/completion'

# rubygems           - use third party tools
# pp                 - pp = pretty print
# awesome_print      - ap = awesome print
# map_by_method      - TODO
# what_methods       - find methods, that create the desired result
# interactive_editor - use vim in irb

included_gems = %w(rubygems pp awesome_print map_by_method what_methods
                   interactive_editor)

included_gems.each do |gem|
  begin
    require gem
  rescue LoadError => err
    warn "#{err}"
  end
end

IRB.conf[:PROMPT_MODE] = :SIMPLE

# irb history
IRB.conf[:EVAL_HISTORY] = 1000
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path('~/.irbhistory')

# indent automatically
IRB.conf[:AUTO_INDENT] = true
