class Postcode < ActiveRecord::Base

  def to_json(*)
    json = JSON.parse(super)

    json['latlon'] = point_to_json(self.latlon)
    json['osgb'] = point_to_json(self.osgb)

    json.to_json
  end

  private

  def point_to_json(point)
    {
      'x' => point.x,
      'y' => point.y,
      'srid' => point.srid
    }

  end

end
