# Demonnic Stopwatch
For if you would like to interact with your stopwatches more like an object.

## Usage
Super basic usage to make a stopwatch and start it from 0
```lua
myStopWatch = demonnic.Stopwatch:new()
myStopWatch:start()
```

Though I recommend you provide a name, as when you do it will pass that name on to Mudlet and it will reuse an existing stopwatch if one with the same name exists.
If you do not provide a name, it will use Geyser.nameGen('stopwatch') to generate a random name for use with Mudlet's stopwatch functions. 
For more information, please check the wiki

## TODO
Could still use some work around persistence. It will set persistence on a timer, but does not always correctly detect that state if a timer with that name already existed. Really should fix that.
