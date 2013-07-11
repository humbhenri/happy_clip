require_relative "clipboard"
require "observer"
require_relative "ui"

class Main
    def initialize
        @clip = ClipboardManager.new
        @clip.add_observer self
        exit_cb = proc { @clip.save_data; @ui.exit }
        selected_cb = proc { @clip.put @ui.selected }
        @ui = Ui.new(@clip.data, exit_cb, selected_cb)
        @ui.start
    end

    # update clipboard info in the ui
    def update(data)
        @ui.update_data data
    end
end

Main.new