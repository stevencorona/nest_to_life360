module Life360

  class Client

    def place(circle_id, place_id)
      request("/circles/#{circle_id}/places/#{place_id}")
    end

  end

end
