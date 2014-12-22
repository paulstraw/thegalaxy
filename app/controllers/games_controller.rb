class GamesController < ApplicationController
  before_action :authorize

  def index
    redirect_to(:new_ship) && return unless current_user.ships.count > 0


    # boostrap necessary game data
    orbiting = current_user.current_ship.currently_orbiting

    gon.current_user = current_user
    gon.current_ship = current_user.current_ship
    gon.currently_orbiting = orbiting.is_a?(Planet) ?
      orbiting.as_json(
        methods: [:name_hex_color],
        include: {
          ships: {
            include: [:faction]
          },
          satellites: {
            methods: [:name_hex_color]
          }
        }
      ) :
      orbiting.as_json(
        methods: [:name_hex_color],
        include: {
          ships: {
            include: [:faction]
          },
          orbitable: {
            methods: [:name_hex_color]
          }
        }
      )
    gon.current_star = current_user.current_ship.currently_orbiting.star.as_json(
      methods: [:name_hex_color],
      include: {
        planets: {
          methods: [:name_hex_color],
          include: {
            satellites: {
              methods: [:name_hex_color],
              ships: {
                include: [:faction]
              },
            },
            ships: {
              include: [:faction]
            },
          }
        }
      }
    )
  end
end
