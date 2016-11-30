require "./logreader/*"

class LogReader
  class Error < Exception; end

  @path : String
  @file : File

  def initialize(path : String)
    @path = File.expand_path(path)
    @file = open_file
  end

  def each
    loop do
      yield read_line
    end
  end

  def read_line : String
    eof_count = 0
    not_exist = false
    String.build do |str|
      loop do
        if char = @file.read_char
          str << char
          break if char == '\n'
          eof_count = 0
          not_exist = false
        elsif eof_count < 5
          sleep(1)
          eof_count += 1
        else
          begin
            @file = reopen_file if File.stat(@path).ino != ino
          rescue err : Errno
            if err.errno != Errno::ENOENT || not_exist
              raise err
            else
              not_exist = true
            end
          ensure
            eof_count = 0
          end
        end
      end
    end
  end

  private def ino
    @file.stat.ino
  end

  private def reopen_file : File
    @file.close unless @file.closed?
    open_file
  end

  private def open_file : File
    raise Error.new("#{@path} is not a readable file.") unless File.file?(@path) && File.readable?(@path)
    File.open(@path)
  end
end
