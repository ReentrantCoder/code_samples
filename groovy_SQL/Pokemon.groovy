import groovy.sql.Sql

/**
 * Created by tylerbehm on 3/25/18.
 */

class Pokemon {
    String name, type
    Integer speed

    Pokemon(Integer id, String type, Sql sql) {
        this.name = getNameDb(id, sql)
        this.type = type
        this.speed = getSpeedDb(id, sql)
    }

    /**
     * Get name FROM database
     *
     * @param id
     * @param sql
     * @return
     */
    static String getNameDb(Integer id, Sql sql) {
        def name = sql.firstRow(
                """
            SELECT identifier FROM pokemon
            INNER JOIN pokemon_species
            ON pokemon.species_id = pokemon_species.id
            WHERE pokemon.id = ${id}
            """)
        name.identifier.capitalize()
    }

    /**
     * Get speed FROM database
     *
     * @param id
     * @param sql
     * @return
     */
    static Integer getSpeedDb(Integer id, Sql sql) {
        def speed = sql.firstRow(
                """
            SELECT base_stat FROM pokemon_stats
            WHERE pokemon_id = ${id} AND stat_id = 6
            """)
        speed.base_stat
    }
}