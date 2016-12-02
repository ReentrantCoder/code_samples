import groovy.sql.Sql

this.getClass().classLoader.rootLoader.addURL(new File("sqlite-jdbc-3.7.2.jar").toURL())
sql = Sql.newInstance( 'jdbc:sqlite:pokedex.sqlite', 'org.sqlite.JDBC' )

types = sql.rows('select identifier, id from types limit 17')
fastestPokemon = []
types.each { type ->
    Pokemon pokemon = new Pokemon()
    id = idFastestByType( type )
    pokemon.name  = idToName( id ).capitalize()
    pokemon.type  = type.identifier
    pokemon.speed = idToSpeed( id )
    fastestPokemon.add(pokemon)
}
fastestPokemon.sort{ it.speed }
fastestPokemon.each{ println( "${it.name} is the fastest ${it.type}-type pokemon. Speed ${it.speed}" ) }

class Pokemon {
    String name, type
    int speed
}

def idFastestByType( type ) {
    id = sql.firstRow(
        """
        select pokemon_id, base_stat from (
        select * from pokemon_stats
        inner join pokemon_types
        on pokemon_stats.pokemon_id = pokemon_types.pokemon_id)
        where type_id = ${type.id} and stat_id = 6
        order by base_stat desc
        """)
    id.pokemon_id
}

def idToName( id ) {
    def name = sql.firstRow(
        """
        select identifier from pokemon
        inner join pokemon_species
        on pokemon.species_id = pokemon_species.id
        where pokemon.id = ${id}
        """)
    name.identifier
}

def idToSpeed( id ) {
    def speed = sql.firstRow(
            """
        select base_stat from pokemon_stats
        where pokemon_id = ${id} and stat_id = 6
        """)
    speed.base_stat
}
