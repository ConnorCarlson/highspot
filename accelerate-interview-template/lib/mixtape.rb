# frozen_string_literal: true

module Mixtape
  def self.apply_changes(mixtape, changes)
    changes.each do |child|
      if child[:type].eql? "add_playlist"
        newObj = child
        newObj.merge!({:id => (mixtape[:playlists].size + 1).to_s, :owner_id => child[:user_id]})
        newObj.delete(:type)
        newObj.delete(:user_id)
        mixtape[:playlists].push(newObj)
      elsif child[:type].eql? "remove_playlist"
        if !mixtape[:playlists].any? {|playlist| playlist[:id] == child[:playlist_id] }
          raise "playlist does not exist"
        end
        mixtape[:playlists] = mixtape[:playlists].reject {|hash| hash[:id].eql? child[:playlist_id]}

      elsif child[:type].eql? "add_song_to_playlist"
        if !mixtape[:playlists].any? {|playlist| playlist[:id] == child[:playlist_id] }
          raise "playlist does not exist"
        end
        if !mixtape[:songs].any? {|song| song[:id] == child[:song_id] }
          raise "song does not exist"
        end
        index = mixtape[:playlists].index{ |list| list[:id].eql? child[:playlist_id]}
        if mixtape[:playlists].fetch(index)[:song_ids].include? child[:song_id]
          raise "song already added to playlist"
        end
        mixtape[:playlists].fetch(index)[:song_ids].push(child[:song_id])

      end
    end
    return mixtape
  end
end
