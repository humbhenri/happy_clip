require "test/unit"
require "../src/clipboard"

class TestClipboard < Test::Unit::TestCase
    def test_read
        clipboard = ClipboardManager.new
        assert !clipboard.peek.empty?
    end

    def test_write
        text = "A Test"
        clipboard = ClipboardManager.new
        clipboard.put text
        assert_equal(text, clipboard.peek)
    end

    def test_capacity
        clipboard = ClipboardManager.new
        capacity = clipboard.capacity
        capacity.times do
            clipboard.put "blah"
        end
        clipboard.put "1"
        clipboard.put "2"
        clipboard.put "3"
        assert_equal(capacity, clipboard.count)
        assert_equal("3", clipboard.peek)
    end
end