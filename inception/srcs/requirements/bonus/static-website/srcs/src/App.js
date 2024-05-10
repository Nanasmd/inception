import React, { useState } from 'react';
import SearchBar from './SearchBar';
import PokemonCard from './PokemonCard';

function App() {
  // Initializes a state variable pokemonData with 
  // a default value of null. This state will store 
  // the data of the Pokémon fetched from the API.
  const [pokemonData, setPokemonData] = useState(null);

  // Defines an asynchronous function handlePokemonSearch 
  // that checks if the search input is empty (just spaces) 
  // and if so, resets pokemonData to null.
  const handlePokemonSearch = async (pokemonName) => {
    if (pokemonName.trim() === '') { // Add this line
      setPokemonData(null);
      return;
    }

  // Tries to fetch Pokémon data from an external API. 
  // If the response isn't okay (e.g., the Pokémon doesn't exist),
  // it throws an error and catches it to handle errors gracefully 
  // by logging them and resetting pokemonData.
    try {
      const response = await fetch(`https://pokeapi.co/api/v2/pokemon/${pokemonName}`);
      if (!response.ok) { throw new Error('No results found'); } 
      const data = await response.json();
      setPokemonData(data);
    } catch (error) {
      console.error('Error fetching data:', error);
      setPokemonData(null);
    }
  };
  // Returns JSX that defines the UI structure of the app. 
  // It includes a title, a subtitle, and the SearchBar and 
  // PokemonCard components. 
  //The SearchBar receives handlePokemonSearch to be called 
  // upon searching.
  return (
    <div className="app">
      <h1 style={{ textAlign: 'center', fontFamily: 'Calibri' }}>Another Pokemon Search</h1>
      <h3 style={{ textAlign: 'center', fontFamily: 'Calibri' }}>When there's no more ships left, we can always count on Pokémon</h3>
      <SearchBar onSearch={handlePokemonSearch} /> 
      <PokemonCard pokemonData={pokemonData} />
    </div>
  );
}
// Makes the App component available for use in other parts 
// of the application, such as index.js.
export default App;