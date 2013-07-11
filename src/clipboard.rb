require "clipboard"
require "observer"
require "thread"

class ClipboardManager

    include Observable

    attr_reader :capacity
    attr_reader :data

    DEFAULT_CAPACITY = 250
    PATH_TO_SAVE_FILE = File.join(Dir.home, "happy_clip")

    def initialize
        load_saved_data
        @capacity = DEFAULT_CAPACITY

        # monitor system clipboard for modifications
        Thread.new do
            while true
                thing = Clipboard.paste
                if thing != peek
                    put thing
                end
                sleep 0.5
            end
        end
    end

    def put(data)
        @data.insert(0, data)
        if @data.count > DEFAULT_CAPACITY
            @data.pop
        end
        Clipboard.copy data
        changed
        notify_observers(data)
        save_data
    end

    def peek
        @data[0]
    end

    def count
        @data.count
    end

    def load_saved_data
        if File.exists? PATH_TO_SAVE_FILE
            File.open(PATH_TO_SAVE_FILE) do |file|
                @data = Marshal.load(file)
                thing = Clipboard.paste
                put thing if thing != peek
            end
        else
            @data = [Clipboard.paste]
        end
    end

    def save_data
        File.open(PATH_TO_SAVE_FILE,'w') do |file|
            Marshal.dump(@data, file)
        end
    end
end