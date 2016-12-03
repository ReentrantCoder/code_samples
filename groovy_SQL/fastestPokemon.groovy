import groovy.sql.Sql

this.getClass().classLoader.rootLoader.addURL(new File("sqlite-jdbc-3.7.2.jar").toURL())
sql = Sql.newInstance( 'jdbc:sqlite:pokedex.sqlite', 'org.sqlite.JDBC' )

types = sql.rows('select identifier, id from types limit 17')
fastestPokemon = []
types.each { type ->
    int id = idFastestByType( type.id )
    Pokemon pokemon = new Pokemon( id, type.identifier, sql )
    fastestPokemon.add(pokemon)
}
fastestPokemon.sort{ it.speed }
fastestPokemon.each{ println( "${it.name} is the fastest ${it.type}-type pokemon. Speed ${it.speed}" ) }

int idFastestByType( int typeID ) {
    id = sql.firstRow(
        """
        select pokemon_id, base_stat from (
        select * from pokemon_stats
        inner join pokemon_types
        on pokemon_stats.pokemon_id = pokemon_types.pokemon_id)
        where type_id = ${typeID} and stat_id = 6
        order by base_stat desc
        """)
    id.pokemon_id
}

class Pokemon {
    String name, type
    Integer speed

    Pokemon(Integer id, String type, Sql sql) {
        this.name = idToName ( id, sql )
        this.type = type
        this.speed = idToSpeed ( id, sql)


    }

    static String idToName( Integer id, Sql sql ) {
        def name = sql.firstRow(
            """
            select identifier from pokemon
            inner join pokemon_species
            on pokemon.species_id = pokemon_species.id
            where pokemon.id = ${id}
            """)
        name.identifier
    }

    static Integer idToSpeed( Integer id, Sql sql ) {
        def speed = sql.firstRow(
            """
            select base_stat from pokemon_stats
            where pokemon_id = ${id} and stat_id = 6
            """)
        speed.base_stat
    }
}

