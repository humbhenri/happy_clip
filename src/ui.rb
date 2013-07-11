require "tk"

class Ui

    def initialize(data_list, exit_cb = nil, selection_cb = nil)
        @oddrow = false

        # main window setup
        @root = TkRoot.new do
            title "Happy Clip"
            minsize(40, 20)
            protocol("WM_DELETE_WINDOW", exit_cb) unless exit_cb.nil?
        end

        # data list configuration
        @tree = Tk::Tile::Treeview.new @root do
            pack("side" => "left", "fill" => "both", "expand" => 1)
            show("tree") # hide column headings
        end
        data_list.reverse.each do |data|
            update_data data
        end
        @tree.tag_configure("oddrow", :background => "#f0f0ff")

        # list selection callback setup
        @tree.bind("Double-ButtonPress-1", selection_cb) unless selection_cb.nil?

        # scrollbar
        @tree.yscrollbar(TkScrollbar.new(@root).pack('side'=>'right', 'fill'=>'y'))
    end

    def start
        Tk.mainloop
    end

    def selected
        selection = @tree.selection
        @tree.itemcget(selection, "text")
    end

    def update_data(data)
        @tree.insert("", 0, :text => data, :tags => [@oddrow ? "oddrow" : ""])
        @oddrow = !@oddrow
    end

    def exit
        @root.destroy
    end
end
