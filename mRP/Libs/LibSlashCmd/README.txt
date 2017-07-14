What is LibSlashCmd?
LibSlashCmd is intended to make handling any and all slash commands simple and worryless. It also has complete slash command clashing protection.


Features:
- Same-name command clashing support.
ex. If you try to register /myaddon but it is already taken, it will (attempt to) register /myaddon2 instead.
LibSlashCmd supports clashing with any and all RIFT slash commands - even with addons that don't use LibSlashCmd.
If you use LibSlashCmd, your slash command will always work, no matter how many addons use your exact slash command. (Allows for up to 9999 same-name slash commands.)

- Simplistic infinite arguments and user input support.

- Your code is (arguably) more organized and easier to read (in comparison to using if/elseif to go through different commands and user input).

- Simple support for fallbacks. If a user enters an unrecognized command, you can (optionally) point them to any function (ex. a message).


How to use it:
With LibSlashCmd, you do not need to worry about registering your command with anything but LibSlashCmd. So no table.insert(Command.Slash.Register("command")...
With LibSlashCmd, you are not required to have a slash command handling function.

First, let's register our command with LibSlashCmd, which will then register it with RIFT.
LibSlashCmd.Register("myaddon", "MyAddon")

The first parameter is the slash command. The second parameter is your addon name. (If the addon name is incorrect, RIFT will complain.)

The Register method returns the command that you will be using throughout your addon. If your command is already in use by another addon, and clashes, then it may be changed to /command2, /command20, /command9999, etc. It will keep trying until it works (from #2 to #9999). (If all 9999 slash command names are taken, the Register method will return nil.)
I suggest creating an addon-wide local to store the Register method return value (the command).
Quote:
local command = nil
command = LibSlashCmd.Register("myaddon", "MyAddon")
The LibSlashCmd.Register should be called when your addon is loading/initializing.

LibSlashCmd.RegisterFunc Examples:
For this example here, when the user types /myaddon ANYTHING, it will fallback to the default function, and print "default".
local command = nil
command = LibSlashCmd.Register("myaddon", "MyAddon")
LibSlashCmd.RegisterFunc(command,
                        "_fallback",
                        function(input)
                            print("default")
                        end)

It's important to note that the fallback function will only be called if no other functions can be found with the user's input.

For the next example, when the user types /myaddon tell me ANYTHING, it will print ANYTHING.
local command = nil
command = LibSlashCmd.Register("myaddon", "MyAddon")
LibSlashCmd.RegisterFunc(command,
                        "tell me",
                        function(input)
                            message = table.concat(input, " ")
                            print(message)
                        end)

It's important to note that arguments can have spaces in them. It will still work fine, and work as intended.
It's also important to note that the function NEEDS to have one argument. That argument is all of the user's input, in a table array, split by one space per value.
You'll notice that, to get all of the input in one string, I used the table.concat method.
I could have used input[0] if I just wanted the first word.

For organization purposes, you may want to put all the RegisterFunc calls into a separate function, and call that function right after you call LibSlashCmd.Register.

As of version 0.3, LibSlashCmd.InvokeFunc is now available.
It allows the developer to invoke a command function from the code with ease.
Example:
LibSlashCmd.InvokeFunc("myaddon", "tell me", "This is a dev test.")
This will produce the same result as if the user typed /myaddon tell me This is a dev test.
This makes debugging, and handling certain scenarios, ex. preset configurations, much easier.
Use less code, and keep the code you are using more consistant. This is one factor that makes LibSlashCmd.InvokeFunc so powerful.