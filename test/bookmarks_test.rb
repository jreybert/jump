# This file is part of the jump project
#
# Copyright (C) 2010 Flavio Castelli <flavio@castelli.name>
# Copyright (C) 2010 Giuseppe Capizzi <gcapizzi@gmail.com>
#
# jump is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# jump is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Keep; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

require "test_helper"
require 'bookmarks'
require 'fileutils'

class BookmarksTest < Test::Unit::TestCase

  def setup
    @test_bookmarks = { "foo" => "/tmp/foo",
                        "bar" => "/tmp/bar",
                        "complex" => "#{File.expand_path '~'}/tmp/foo/bar/complex"}
    FakeFS do
      FileUtils.mkdir_p(File.expand_path('~'))
      File.open(Bookmarks::BOOKMARKS_PATH, 'w') do |file|
        file << YAML::dump(@test_bookmarks)
      end

      @bookmarks = Bookmarks.new
    end
  end

  def test_expand_path
    @test_bookmarks.each do |bookmark, expected_path|
      current_path = @bookmarks.expand_path bookmark
      assert_equal expected_path, current_path
    end

    # check absolute path
    assert_equal "/foo", @bookmarks.expand_path("/foo")

    # check multiple / handling
    assert_equal "/tmp/foo/1/2", @bookmarks.expand_path("foo/1/2")
  end

  def test_add
    # should add a new bookmark
    bookmark = "flavio_home"
    path = "/home/flavio"
    @bookmarks.add(path, bookmark)
    assert_equal path, @bookmarks.expand_path(bookmark)

    #should update a bookmark
    new_path = "/tmp"
    @bookmarks.add(new_path, bookmark)
    assert_equal new_path, @bookmarks.expand_path(bookmark)
  end

  def test_to_s
    output = <<EOF
---------------------------------
 Bookmark  Path                  
---------------------------------
 bar       /tmp/bar              
 complex   ~/tmp/foo/bar/complex 
 foo       /tmp/foo              
---------------------------------
EOF
    assert_equal output.chomp, @bookmarks.to_s
  end

  def test_save
    bookmark = "flavio_home"
    path = "/home/flavio"
    @bookmarks.add(path, bookmark)

    expected_bookmarks = @test_bookmarks.dup
    expected_bookmarks[bookmark] = path

    FakeFS do
      @bookmarks.save

      assert File.exists?(Bookmarks::BOOKMARKS_PATH)
      contents = YAML::load_file Bookmarks::BOOKMARKS_PATH
      assert_equal expected_bookmarks, contents
    end
  end
end

