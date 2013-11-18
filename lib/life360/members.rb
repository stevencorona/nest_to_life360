module Life360

  class Client

    def members(circle_id)
      request("circles/#{circle_id}/members")
    end

      def members_in_place?(circle_id, place_id)

    members = self.members(circle_id)
    place = self.place(circle_id, place_id)

    result = {}

    members["members"].each do |member|

      in_place = false

      distance_from_place = haversine(member["location"]["latitude"].to_f, member["location"]["longitude"].to_f,
        place["latitude"].to_f, place["longitude"].to_f)

      if (distance_from_place <= place["radius"].to_i)
        in_place = true
      end

      result[member["id"]] = in_place

    end

    result

  end

  end

end
