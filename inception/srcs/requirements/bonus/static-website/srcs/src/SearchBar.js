import React, { useState } from 'react';
import './SearchBar.css';

function SearchBar({ onSearch }) {
  const [pokemonName, setPokemonName] = useState('');

  const handleChange = (event) => {
    setPokemonName(event.target.value);
  };

  const handleClick = () => {
    if (pokemonName.trim() !== '') { // Add this line
      onSearch(pokemonName.toLowerCase());
    }
  };

  return (
    <div style={{ textAlign: 'center' }}>
      <input 
        onChange={handleChange}
        className="search-input" 
        type="text" 
        placeholder="What Pokémon will you choose?" />
      <button onClick={handleClick} className="search-button">Search</button>
    </div>
  );
}

export default SearchBar;

/* Implements the SearchBar component which includes 
an input field and a search button. This component manages 
its own state for the input value and provides functionality 
to initiate a search when the button is clicked, 
susing the provided onSearch function passed as a prop. */