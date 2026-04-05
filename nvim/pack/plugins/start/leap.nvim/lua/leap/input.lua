local keycode = vim.keycode

local function get_char()
   local ok, ch = pcall(vim.fn.getcharstr)  -- for <C-c>
   if ok and (ch ~= keycode('<esc>')) then return ch end
end

--- Waits for keymapped sequences (see :help mbyte-keymap).
--- Gets and returns a `prompt` value, so that multiple calls
--- can be sequenced.
local function get_char_keymapped(prompt)
   prompt = prompt or '>'

   local function echo_prompt(seq)
      vim.api.nvim_echo({ { prompt }, { seq or '', 'ErrorMsg' } }, false, {})
   end

   local function accept(ch)
      prompt = prompt .. ch
      echo_prompt()
      return ch
   end

   local function loop(seq)
      local len_seq = #(seq or '')
      -- Arbitrary limit (`mapcheck()` will continue to give back a
      -- candidate if the start of `seq` matches, need to cut the
      -- gibberish somewhere).
      if (1 <= len_seq) and (len_seq <= 5) then
         echo_prompt(seq)

         local candidate = vim.fn.mapcheck(seq, 'l')
         local exact_match = vim.fn.maparg(seq, 'l')

         if candidate == '' then
            -- Accept the sole input character as it is
            -- (implies #seq=1, no recursion here).
            return accept(seq)
         elseif exact_match == candidate then
            -- TODO: It is not safe what we're doing here. According to
            -- `:h mapcheck`, the candidate is random, it is not
            -- guaranteed to belong to a longer LHS (seq). Thus we don't
            -- really have a condition on which we could accept a
            -- matching char automatically, without checking the
            -- keyboard map itself.
            return accept(exact_match)
         else
            local ch = get_char()
            if ch == keycode('<bs>') then
               -- Delete back a character.
               local seq_ = len_seq < 2 and seq or seq:sub(1, len_seq - 1)
               return loop(seq_)
            elseif ch == keycode('<cr>') then
               -- Force accepting the current input, if valid.
               return exact_match ~= '' and accept(exact_match)
                  or len_seq == 1 and accept(seq)
                  or loop(seq)
            else
               -- Consume and continue.
               return loop(seq .. ch)
            end
         end
      end
   end

   if vim.bo.iminsert == 1 then
      echo_prompt()
      local input = loop(get_char())
      if input then
         return input, prompt
      else
         vim.api.nvim_echo({ { '' } }, false, {})
      end
   else
      -- No keymap is active.
      return get_char()
   end
end

return {
    get_char = get_char,
    get_char_keymapped = get_char_keymapped
}
