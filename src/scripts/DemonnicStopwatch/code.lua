demonnic = demonnic or {}

--- demonnic.Stopwatch
--Creates a stopwatch 'object' to abstract some of the stopwatch functionality
--@module demonnic.Stopwatch
demonnic.Stopwatch = {}

--- Returns the stopwatch time
-- @tparam string format format to return the time in. If not set or the empty string "" returns time from getStopWatchTime(self.name), otherwise attempts to format according to
-- "hh" is hours with leading 0 (00 - 24)
-- "h" is hours without leading 0 (0-24)
-- "mm" is milliseconds with leading 0s (000 - 999)
-- "m" is milliseconds without leading 0s (0-999)
-- "MM" is minutes with leading 0s (01 - 59)
-- "M" is minutes without leading 0s (1-59)
-- "dd" is days with one leading 0 (0 - ...)
-- "d" is days without leading 0 (0 - ...)
function demonnic.Stopwatch:getTime(format)
  format = format or ""
  local formatType = type(format)
  assert(formatType == "string", string.format("bad argument #1 type(optional format as string expected, got %s!", formatType))
  if format == "" then
    format = getStopWatchTime(self.name)
  else
    local time = self:getTimeTable()
    format = format:gsub("mm", string.format("%03d", time.milliSeconds))
    format = format:gsub("m", time.milliSeconds)
    format = format:gsub("MM", string.format("%02d", time.minutes))
    format = format:gsub("M", time.minutes)
    format = format:gsub("dd", string.format("%02d", time.days))
    format = format:gsub("d", time.days)
    format = format:gsub("ss", string.format("%02d",time.seconds))
    format = format:gsub("s", time.seconds)
    format = format:gsub("hh", string.format("%02d", time.hours))
    format = format:gsub("h", time.hours)
  end
  return format
end

--- Returns the broken down time table
function demonnic.Stopwatch:getTimeTable()
  return getStopWatchBrokenDownTime(self.name)
end

--- Returns the full table found only in getStopWatches() output
function demonnic.Stopwatch:getExpandedTable()
  for _,watch in ipairs(getStopWatches()) do
    if watch.name == self.name then return watch end
  end
end

--- Returns true if the stopwatch is running, false if not
function demonnic.Stopwatch:isRunning()
  local expandedTable = self:getExpandedTable()
  return expandedTable.isRunning
end

--- Resets the stopwatch
function demonnic.Stopwatch:reset()
  return resetStopWatch(self.name)
end

--- Starts the stopwatch
function demonnic.Stopwatch:start()
  return startStopWatch(self.name)
end

--- Stops the stopwatch
function demonnic.Stopwatch:stop()
  return stopStopWatch(self.name)
end

--- Enables persistence on the stopwatch
function demonnic.Stopwatch:enablePersistence()
  self.persistence = true
  return setStopWatchPersistence(self.name, self.persistence)
end

--- Disables persistence on the stopwatch
function demonnic.Stopwatch:disablePersistence()
  self.persistence = false
  return setStopWatchPersistence(self.name, self.persistence)
end

--- Returns current persistence state
function demonnic.Stopwatch:getPersistence()
  return self.persistence
end

--- Adjusts the stopwatch by the number of seconds passed in
--@tparam number seconds number of seconds to adjust the stopwatch by
function demonnic.Stopwatch:adjust(seconds)
  local secondsType = type(seconds)
  assert(secondsType == "number", string.format("bad argument #1 type, (seconds as number expected, got %s", secondsType))
  return adjustStopWatch(self.name, seconds)
end

--- Sets a new name for the stop watch.
-- Does not change the internal representation of the name unless the underlying name change is successful
-- @tparam[opt] string name the new name for the stopwatch. If none or empty string is passed will generate a name.
function demonnic.Stopwatch:setName(name)
  name = name or ""
  local nameType = type(name)
  assert(nameType == "string", string.format("bad argument #1 type, (optional name as string expected, got %s", nameType))
  if name == "" then 
    name = Geyser.nameGen("stopwatch")
  end
  local success,error = setStopWatchName(self.name, name)
  if success then
    self.name = name
    return success
  else
    return success, error
  end
end

--- Creates a new stopwatch instance and returns it.
-- @tparam[opt] table cons table of constraints for the stopwatch
-- valid constraints are:
-- name: string, used for the name of the stopwatch. If not provided one will be generated.
-- startAt: number, used to adjust the stopwatch time at instantiation
-- persistence: boolean, if defined will make the stopwatch persistent. Defaults to nonpersistent.
function demonnic.Stopwatch:new(cons)
  cons = cons or {}
  local consType = type(cons)
  assert(consType == "table", string.format("bad argument #1 type, (optional cons as table expected, got %s!)", consType))
  local me = table.deepcopy(cons)
  setmetatable(me, self)
  self.__index = self
  me.name = me.name or Geyser.nameGen("stopwatch")
  local nameType = type(me.name)
  assert(nameType == "string", string.format("Bad constraint, (optional name as string expected, got %s!", nameType))
  createStopWatch(me.name)
  if me.startAt then
    local startAtType = type(me.startAt)
    assert(startAtType == "number", string.format("Bad constraint, (optional startAt as number expected, got %s!", startAtType))
    me:adjust(me.startAt)
  end
  if me.persistence then
    me:enablePersistence()
  else
    me:disablePersistence()
  end
  return me
end
