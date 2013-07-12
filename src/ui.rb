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
        frame_top = Tk::Tile::Frame.new @root do
            padding "0 0 0 0"
            pack("side" => "top", "fill" => "both", "expand" => 1)
        end
        @tree = Tk::Tile::Treeview.new frame_top do
            pack("side" => "left", "fill" => "both", "expand" => 1)
            show("tree") # hide column headings
        end
        data_list.reverse.each do |data|
            update_data data
        end
        @tree.tag_configure("oddrow", :background => "#f0f0ff")

        # list selection callback setup
        @tree.bind("Double-ButtonPress-1", selection_cb) unless selection_cb.nil?

        # list scrollbar
        @tree.yscrollbar(TkScrollbar.new(frame_top).pack("side" => "right", "fill" => "y"))

        # search bar
        frame_bottom = Tk::Tile::Frame.new @root do
            padding "0 0 0 0"
            pack("side" => "bottom", "fill" => "x")
        end
        search_btn = Tk::Tile::Button.new frame_bottom do
            image(TkPhotoImage.new("file"=>"../res/search.GIF"))
            pack("side" => "left")
        end
        search_btn.command { search }
        @search_txt = Tk::Tile::Entry.new(frame_bottom) do
            pack("side" => "right", "fill" => "x", "expand" => 1)
        end
        @search_txt.bind("Return", proc { search })

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
        @oddrow = !@oddrow # keep alternated colors
    end

    def exit
        @root.destroy
    end

    def search
        search_item = @search_txt.get
        @tree.children("").reverse.each do | item |
            if  @tree.itemcget(item, "text").match /#{search_item}/
                @tree.selection_set item
                @tree.see item
            end
        end
    end
end
