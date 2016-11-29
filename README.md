# LogReader

Reading lines in the text file which is growing and may be rotated, such as unix system log file.

* When the current file reaches EOF, this will wait new line added to the file. (like `tail -f` command)
* Even when the current file is rotated, this will trace new file and continue reading lines.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  logchaser:
    github: arcage/crystal-logreader
```

## Usage

```crystal
require "logreader"

# create LogReader object
log = LogReader.new("/var/log/maillog")

# reads single line from the file
# waits new line, when the file reaches EOF
puts log.read_line

# iterates each line in the file
log.each do |line|
  puts line
end
```

`LogReader` has only two public instance method `#read_line` and `#each`

`#each` will not finish in normal operation. if you want to stop it, you have to do it forcibly by using `Ctrl+C`, `kill` command etc.

### Internal behaviour

When reading no data for reasons such as EOF, `LogReader` try to read more data every second.

For every consecutive 5 results that no data read, `LogReader` checks whether or not the inode number associated with the file name was changed.

If it had been changed, `LogReader` close current file and re-open the file.

## Contributors

- [arcage](https://github.com/arcage) ʕ·ᴥ·ʔAKJ - creator, maintainer
