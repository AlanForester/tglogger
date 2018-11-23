print (" v1.0")

now = os.time()
home_dir = "/home/telegramd/"

function send_msg_cb(cb_extra, success, result)
    if success then
        return
    end
end

function postpone_cb(cb_extra, success, result)
    postpone (postpone_cb, "", 1)
end

redis = require 'redis'

function on_msg_receive (msg)
    ---send_msg (msg.from.print_name, msg.text, send_msg_cb, "")
    if msg.date < now then
        return
    end
    ---if msg.out then
    ---    return
    ---end
    ---mark_read (msg.from.print_name)
    if msg.text then
        local f = io.open(home_dir..'inbox', 'a')
        local clr = msg.text:gsub('%;', '.')
        clr = clr:gsub("%\\n", " ")
	    clr = clr:gsub("\n", ". ")
        clr = clr:gsub('%"', '*')
	    clr = clr:gsub("%\\", "*")
        clr = clr:gsub("%'", "*")
	    local is_me = "false"
	    if (msg.from.peer_id == our_id) then
	      is_me = "true"
	    end
	    local client = redis.connect('127.0.0.1', 6379)
	    local log = msg.from.peer_id..';'..msg.to.peer_id..';'..msg.date..';'..is_me..';'..clr
	    client:set('tglog:'..msg.from.id, log)
        f:write(log..'\n')
        f:flush()
        f:close()
    end
end

function on_our_id (id)
    --- print(id)
    our_id = id
    postpone (postpone_cb, "", 1)
end

function on_user_update (user, what)
end

function on_chat_update (chat, what)
end

function on_secret_chat_update (schat, what)
end

function on_get_difference_end ()
end

function on_binlog_replay_end ()
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string:split( inSplitPattern, outResults )
   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end
