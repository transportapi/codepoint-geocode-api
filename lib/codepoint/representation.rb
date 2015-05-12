# this module is all about representation of the Postcode resource.
# Module named 'Codepoint' to avoid namespace conflicts with Postcode model.
# Transforms either one postcodes or a collection (as ActiveRecord Relations)
# and transforms to a standardised hash rep.
module Codepoint
  module Representation

    module_function

    # Builds a hash rep of the postcode resource
    def postcode(postcode)

      { postcode: postcode.postcode,
        positional_quality_indicator: postcode.positional_quality_indicator,
        postcode_nows: postcode.postcode_nows,
        osgb: {
          x: postcode.osgb.x,
          y: postcode.osgb.y,
          srid: postcode.osgb.srid
        },
        latlon: {
          x: postcode.latlon.x,
          y: postcode.latlon.y,
          srid: postcode.latlon.srid
        }
      }
    end

    # Builds a hash rep of the postcodes collection resource
    # REVIEW - mandatory inclusion of dist param. May not be mandatory in future
    # E.G.  a collection of postcodes matching the pattern 'EX8'
    def postcode_collection(postcodes)
      resource = []
      postcodes.each do |postcode|
        # this postcode representation must also include distance
        resource.push( postcode(postcode).merge( {dist: postcode.dist.round} ) )
      end

      resource
    end
  end
end