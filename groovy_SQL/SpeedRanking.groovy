import groovy.sql.GroovyRowResult
import groovy.sql.Sql

this.getClass().classLoader.rootLoader.addURL(new File("sqlite-jdbc-3.7.2.jar").toURL())
sql = Sql.newInstance( 'jdbc:sqlite:Pokedex.sqlite', 'org.sqlite.JDBC' )

/**
 * Find the id of the faster pokemon by type in database
 *
 * @param typeId
 * @return
 */
int findIdFastestByType(int typeId) {
    GroovyRowResult result = sql.firstRow(
            """
        SELECT pokemon_id, base_stat FROM (
        SELECT * FROM pokemon_stats
        INNER JOIN pokemon_types
        ON pokemon_stats.pokemon_id = pokemon_types.pokemon_id)
        WHERE type_id = ${typeId} AND stat_id = 6
        ORDER BY base_stat DESC
        """)
    result.pokemon_id
}

List<GroovyRowResult> types = sql.rows('SELECT identifier, id FROM types WHERE identifier NOT IN ("unknown", "shadow")')
fastestPokemon = []
types.each { GroovyRowResult type ->
int id = findIdFastestByType(type.id)
    Pokemon pokemon = new Pokemon(id, type.identifier, sql)
    fastestPokemon.add(pokemon)
}
fastestPokemon.sort{ it.speed }
fastestPokemon.each{ println( "${it.name} is the fastest ${it.type}-type pokemon. Speed ${it.speed}" ) }

