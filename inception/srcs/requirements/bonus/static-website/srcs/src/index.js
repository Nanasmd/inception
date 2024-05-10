import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';

/*Loads the React library, ReactDOM for rendering, 
the App component, and the index.css style sheet.*/

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

/*Uses ReactDOM to render the App component within 
the root DOM element of the HTML document, wrapped in 
<React.StrictMode> for catching potential problems in 
an application.*/